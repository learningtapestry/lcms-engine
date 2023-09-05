# frozen_string_literal: true

module DocTemplate
  class Document
    MAX_PARSE_ITERATIONS = 300

    # Contains the list of tags for which no parts should be created
    TAGS_WITHOUT_PARTS = [
      Tags::DefaultTag::TAG_NAME,
      Tags::GlsTag::TAG_NAME,
      Tags::MaterialsTag::TAG_NAME,
      '#'
    ].freeze

    ELA_TG_TEMPLATE = Lcms::Engine::Engine.root.join 'lib', 'doc_template', 'templates', 'ela-teacher-guidance.html.erb'

    attr_accessor :errors, :parts

    def self.parse(nodes, opts = {})
      new.parse(nodes, opts)
    end

    def initialize
      @errors = []
      @parts = []
    end

    def parse(nodes, opts = {})
      @nodes = nodes
      @opts = opts
      @parts = @opts[:parts] || []

      # find all tags except ones which were marked as parsed first and nested levels
      xpath = [%(*[not(contains(@data-parsed, "true"))]/#{::DocTemplate::STARTTAG_XPATH}),
               %(*//*[not(contains(@data-parsed, "true"))]/#{::DocTemplate::STARTTAG_XPATH})]
      while (node = @nodes.at_xpath(*xpath))
        # identify the tag, take the siblings or enclosing and send it to the
        # relative tag class to render it
        next unless (tag_node = node.parent)

        handle_invalid_tag tag_node
        parse_node tag_node
      end

      self
    end

    def render
      @nodes.to_html
    end

    private

    #
    # Check if we're getting the same tag again
    #
    def check_loop_tag(name, value)
      if @opts.dig(:last_tag, :name) == name && @opts.dig(:last_tag, :value) == value &&
         @opts.dig(:last_tag, :iteration) > DocTemplate::Document::MAX_PARSE_ITERATIONS
        raise ::Lcms::Engine::DocumentError, "Loop detected for tag #{name} with value #{value}"
      end
    end

    def find_tag(name, value = '')
      key = registered_tags.keys.detect do |k|
        if k.is_a?(Regexp)
          name =~ k
        else
          k == name or k == [name, value].join(' ')
        end
      end
      registered_tags[key]
    end

    #
    # catch invalid tags and report about them
    #
    def handle_invalid_tag(node)
      return if ::DocTemplate::FULL_TAG.match(node.text).present?

      raise Lcms::Engine::DocumentError, "No closing bracket for node:<br>#{node.to_html}"
    end

    def parse_node(node)
      matches = FULL_TAG.match(node.text)
      return if matches.nil?

      tag_name, tag_value = matches.captures
      return unless (tag = find_tag tag_name.to_s.downcase, tag_value.to_s.downcase)

      # Did we get the same tag as previous?
      check_loop_tag tag_name, tag_value

      parsed_tag = tag.parse(node, @opts.merge(parent_document: self, value: tag_value))
      @errors.push(*parsed_tag.errors) if parsed_tag.errors.any?
      store_last_tag tag_name, tag_value

      parsed_content = parsed_tag.content.presence || parsed_tag.render.to_s
      sanitized_content = ::DocTemplate.sanitizer.post_processing(parsed_content, @opts)

      return if TAGS_WITHOUT_PARTS.include?(tag::TAG_NAME)

      parts << {
        anchor: parsed_tag.anchor.to_s,
        content: parsed_tag.try(:without_squish?) ? sanitized_content : sanitized_content.squish,
        context_type: @opts[:context_type],
        data: parsed_tag.tag_data,
        materials: parsed_tag.materials,
        optional: (parsed_tag.try(:optional?) || false),
        placeholder: parsed_tag.placeholder,
        part_type: tag_name.to_s.underscore
      }
    end

    def registered_tags
      Template.tags
    end

    #
    # Save info about the latest parsed tag
    #
    def store_last_tag(name, value)
      iteration =
        if @opts.dig(:last_tag, :name) != name && @opts.dig(:last_tag, :value) != value
          0
        else
          @opts.dig(:last_tag, :iteration).to_i + 1
        end

      @opts[:last_tag] = {
        iteration:,
        name:,
        value:
      }
    end
  end
end
