# frozen_string_literal: true

module DocTemplate
  class Document
    MAX_PARSE_ITERATIONS = 100

    # Contains the list of tags for which no parts should be created
    TAGS_WITHOUT_PARTS = [
      Tags::DefaultTag::TAG_NAME,
      Tags::GlsTag::TAG_NAME,
      Tags::MaterialsTag::TAG_NAME,
      '#'
    ].freeze

    ELA_TG_TEMPLATE = Lcms::Engine::Engine.root.join 'lib', 'doc_template', 'templates', 'ela-teacher-guidance.html.erb'

    attr_accessor :parts

    def self.parse(nodes, opts = {})
      new.parse(nodes, opts)
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

      add_custom_nodes unless @opts.key?(:level) || @opts.key?(:material)

      self
    end

    def render
      @nodes.to_html
    end

    private

    def add_custom_nodes
      return unless @opts[:metadata].try(:subject).to_s.casecmp('ela').zero?
      return unless ela_teacher_guidance_allowed?

      ::DocTemplate.sanitizer.strip_content(@nodes)
      @nodes.prepend_child ela_teacher_guidance(@opts[:metadata], @opts[:context_type])
    end

    #
    # Check if we're getting the same tag again
    #
    def check_loop_tag(name, value)
      if @opts.dig(:last_tag, :name) == name && @opts.dig(:last_tag, :value) == value &&
         @opts.dig(:last_tag, :iteration) > DocTemplate::Document::MAX_PARSE_ITERATIONS
        raise ::DocumentError, "Loop detected for tag #{name} with value #{value}"
      end
    end

    def ela_teacher_guidance(metadata, _context_type)
      @data = metadata
      @data.preparation = ::DocTemplate.sanitizer.strip_html_element(@data.preparation)
      template = File.read ELA_TG_TEMPLATE
      ERB.new(template).result(binding)
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
    def ela_teacher_guidance_allowed?
      # only for G6 and G2
      # As stated on issue #240 and here https://github.com/learningtapestry/unbounded/pull/267#issuecomment-307870881
      g2 = @opts[:metadata]['grade'] == '2'
      g6 = @opts[:metadata]['grade'] == '6'
      return false unless g2 || g6

      # Additional filter for lessons
      # https://github.com/learningtapestry/unbounded/issues/311
      # https://github.com/learningtapestry/unbounded/issues/240

      # G2 Unit 1 apart from for Lessons: 6,10,11,12
      g2_u1 = g2 && @opts[:metadata]['unit'] == '1'
      return false if g2_u1 && %w(6 10 11 12).include?(@opts[:metadata]['lesson'])

      # G2 Unit 2 apart from for Lessons: 8,16,17,18
      g2_u2 = g2 && @opts[:metadata]['unit'] == '2'
      return false if g2_u2 && %w(8 16 17 18).include?(@opts[:metadata]['lesson'])

      # G2 Unit 3 apart from for Lessons: 8,14,15,16
      g2_u3 = g2 && @opts[:metadata]['unit'] == '3'
      return false if g2_u3 && %w(8 14 15 16).include?(@opts[:metadata]['lesson'])

      # G2 Unit 4 apart from for Lessons: 8,13,14,15
      g2_u4 = g2 && @opts[:metadata]['unit'] == '4'
      return false if g2_u4 && %w(8 13 14 15).include?(@opts[:metadata]['lesson'])

      # G2 Unit 5 apart from for Lessons: 5,10,11,12
      g2_u5 = g2 && @opts[:metadata]['unit'] == '5'
      return false if g2_u5 && %w(5 10 11 12).include?(@opts[:metadata]['lesson'])

      # G2 Unit 6 apart from for Lessons: 6,11,12,13
      g2_u6 = g2 && @opts[:metadata]['unit'] == '6'
      return false if g2_u6 && %w(6 11 12 13).include?(@opts[:metadata]['lesson'])

      # G2 Unit 7 apart from for Lessons: 6,11,12,13
      g2_u7 = g2 && @opts[:metadata]['unit'] == '7'
      return false if g2_u7 && %w(6 11 12 13).include?(@opts[:metadata]['lesson'])

      # G2 Unit 8 apart from for Lessons: 5,12,11,10
      g2_u8 = g2 && @opts[:metadata]['unit'] == '8'
      return false if g2_u8 && %w(5 12 11 10).include?(@opts[:metadata]['lesson'])

      # G2 Unit 9 apart from for Lessons: 15,14,13,6
      g2_u9 = g2 && @opts[:metadata]['unit'] == '9'
      return false if g2_u9 && %w(15 14 13 6).include?(@opts[:metadata]['lesson'])

      # G2 Unit 10 apart from for Lessons: 11,13,5,12
      g2_u10 = g2 && @opts[:metadata]['unit'] == '10'
      return false if g2_u10 && %w(11 13 5 12).include?(@opts[:metadata]['lesson'])

      # G2 Unit 11 apart from for Lessons: 14,12,7,13
      g2_u11 = g2 && @opts[:metadata]['unit'] == '11'
      return false if g2_u11 && %w(14 12 7 13).include?(@opts[:metadata]['lesson'])

      # G2 Unit 12 apart from for Lessons: 12,13,6,11
      g2_u12 = g2 && @opts[:metadata]['unit'] == '12'
      return false if g2_u12 && %w(12 13 6 11).include?(@opts[:metadata]['lesson'])

      true
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize

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

      raise DocumentError, "No closing bracket for node:<br>#{node.to_html}"
    end

    def parse_node(node)
      matches = FULL_TAG.match(node.text)
      return if matches.nil?

      tag_name, tag_value = matches.captures
      return unless (tag = find_tag tag_name.downcase, tag_value.downcase)

      # Did we get the same tag as previous?
      check_loop_tag tag_name, tag_value

      parsed_tag = tag.parse(node, @opts.merge(parent_document: self, value: tag_value))
      store_last_tag tag_name, tag_value

      parsed_content = parsed_tag.content.presence || parsed_tag.render.to_s
      sanitized_content = ::DocTemplate.config['sanitizer'].constantize
                            .post_processing(parsed_content, @opts)

      return if TAGS_WITHOUT_PARTS.include?(tag::TAG_NAME)

      parts << {
        anchor: parsed_tag.anchor.to_s,
        content: sanitized_content.squish,
        context_type: @opts[:context_type],
        data: parsed_tag.tag_data,
        materials: parsed_tag.materials,
        optional: (parsed_tag.try(:optional?) || false),
        placeholder: parsed_tag.placeholder,
        part_type: tag_name.underscore
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
        iteration: iteration,
        name: name,
        value: value
      }
    end
  end
end
