# frozen_string_literal: true

module DocTemplate
  module Tags
    class BaseTag
      SOFT_RETURN_RE = /([[:graph:]]+\[|\][[:graph:]]+)/.freeze
      UNICODE_SPACES_RE = /(\u0020|\u00A0|\u1680|\u180E|[\u2000-\u200B]|\u202F|\u205F|\u3000|\uFEFF)/.freeze

      attr_reader :anchor, :content

      class << self
        def parse(node, opts = {})
          new.parse(node, opts)
        end

        def tag_with_html_regexp
          raise NotImplementedError unless const_defined?(:TAG_NAME)

          @tag_with_html_regexp ||= /\[[^\]]*#{self::TAG_NAME}[[^:,;.]]*:?\s?[^\]]*\]/i
        end

        def template_path_for(name)
          File.join ::Lcms::Engine::Engine.root.join('lib', 'doc_template', 'templates'), name
        end
      end

      #
      # Precede the specified element with tag's placeholder
      #
      def before_tag(node)
        node.before Nokogiri::HTML.fragment(placeholder)
      end

      def check_tag_soft_return(node)
        # need to remove unicode spaces bc they're not handled by [[:graph:]]
        return unless node.content.gsub(UNICODE_SPACES_RE, '') =~ SOFT_RETURN_RE

        raise ::DocumentError,
              "Soft return for #{self.class::TAG_NAME} detected: #{node.content}, use hard return instead"
      end

      def content_until_break(node)
        [].tap do |result|
          check_tag_soft_return(node)
          while (sibling = node.next_sibling)
            break if include_break?(sibling)

            result << sibling.to_html
            sibling.remove
          end
        end.join
      end

      def content_until_materials(node)
        [].tap do |result|
          check_tag_soft_return(node)
          while (sibling = node.next_sibling)
            break if include_break_for?(sibling, 'stop_materials_tags')

            result << sibling.to_html
            sibling.remove
          end
        end.join
      end

      def ela2?(metadata)
        metadata.resource_subject == 'ela' && metadata.grade == '2'
      end

      def ela6?(metadata)
        metadata.resource_subject == 'ela' && metadata.grade == '6'
      end

      def gdoc?(opts)
        opts[:context_type].to_s.casecmp('gdoc').zero?
      end

      def include_break?(node)
        include_break_for? node, 'stop_tags'
      end

      def include_break_for?(node, key)
        stop_tags = Array.wrap ::DocTemplate::Tags.config[self.class::TAG_NAME.downcase][key]
        return false if stop_tags.empty?

        tags = stop_tags.map { |t| ::DocTemplate::Tags.const_get(t)::TAG_NAME }.join('|')

        result = node.content =~ /\[\s*(#{tags})/i
        check_tag_soft_return(node) if result
        result
      end

      def materials
        @materials || []
      end

      def parse(node, _options = {})
        @result = node
        remove_tag
        self
      end

      def parse_nested(node, opts = {})
        if node == opts[:parent_node]
          opts[:iteration] = opts[:iteration].to_i + 1
          if opts[:iteration] > DocTemplate::Document::MAX_PARSE_ITERATIONS
            raise ::DocumentError, "Loop detected for node:<br>#{node}"
          end
        end
        parsed = ::DocTemplate::Document.parse(Nokogiri::HTML.fragment(node), opts.merge(level: 1))
        # add the parts to the parent document
        opts[:parent_document].parts += parsed.parts if opts[:parent_document]
        parsed.render
      end

      def parse_template(context, template_name)
        @tmpl = context
        template = File.read template_path(template_name)
        ERB.new(template).result(binding)
      end

      def placeholder
        @placeholder ||= "{{#{placeholder_id}}}"
      end

      def placeholder_id
        @placeholder_id ||= "#{self.class.name.demodulize.underscore}_#{SecureRandom.hex(10)}"
      end

      def render
        @result.to_s.presence || placeholder
      end

      #
      # Replace the tag element with its placeholder. Or inline the
      # tag if requested
      #
      def replace_tag(node)
        replacement = @opts&.[](:explicit_render) ? content : Nokogiri::HTML.fragment(placeholder)
        node.replace replacement
      end

      def tag_data
        {}
      end

      #
      # First look for the template override inside possible gems
      # And use standard one if not found
      #
      def template_name(opts)
        context = opts.fetch(:context_type, :default).to_s
        override =
          ::DocTemplate::Tags.config.dig(self.class::TAG_NAME.to_s.downcase, 'templates', context)
        override.presence || self.class::TEMPLATES[context.to_sym]
      end

      def template_path(name)
        custom_path =
          Array.wrap(::DocTemplate::Tags.config['templates_paths']).detect do |path|
            File.exist?(File.join path.to_s, name)
          end
        custom_path.present? ? File.join(custom_path, name) : self.class.template_path_for(name)
      end

      private

      def remove_tag
        start_tag_index = @result.children.index(@result.at_xpath(STARTTAG_XPATH))
        end_tag_index = @result.children.index(@result.at_xpath(ENDTAG_XPATH))
        @result.children[start_tag_index..end_tag_index].each do |node|
          if node.content.match?(/.+\[[^\]]+\]|\[[^\]]+\].+/)
            # a tag followed or preceeded by anything else
            # removes the tag itself - everything between `[` and `]`
            node.content = node.content.sub(/\[[^\[\]]+\]/, '')
          elsif (data = node.content.match(/^([^\[]*)\[|\]([^\[]*)$/))
            # if node contains open or closing tag bracket with general
            # text outside the bracket itself
            if (new_content = data[1].presence || data[2]).blank?
              node.remove
            else
              node.content = new_content
            end
          else
            node.remove
          end
        end
      end
    end
  end
end
