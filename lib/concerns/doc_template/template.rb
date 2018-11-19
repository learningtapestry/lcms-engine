# frozen_string_literal: true

module Concerns
  module DocTemplate
    module Template
      extend ActiveSupport::Concern

      class TagRegistry
        include Enumerable

        def initialize
          @tags = {}
        end

        # returns the default tag if the tag is unknown
        def [](tag_name)
          tag_to_load = @tags.key?(tag_name) ? tag_name : 'default'
          @tags[tag_to_load]
        end

        def []=(tag_name, klass)
          @tags[tag_name] = klass
        end

        def keys
          @tags.keys
        end

        private

        def load_class(klass_name)
          Object.const_get(klass_name)
        end
      end

      included do
        attr_reader :css_styles, :metadata_service, :toc

        private

        attr_accessor :content
      end

      def initialize(type = :document)
        @type = type
        @documents = {}
      end

      def material?
        @type.to_sym == :material
      end

      def metadata
        metadata_service.metadata.data.presence || {}
      end

      def parse(source)
        doc = Nokogiri::HTML(source)
        # get css styles from head to keep classes for lists (preserve list-style-type)
        doc = DocTemplate.sanitizer.process_list_styles doc
        @css_styles = DocTemplate.sanitizer.sanitize_css(doc.xpath('//html/head/style/text()').to_s)

        # initial content sanitization
        body_node = ::DocTemplate
                      .config['sanitizer'].constantize
                      .sanitize(doc.xpath('//html/body/*').to_s)
        @content = Nokogiri::HTML.fragment(body_node)

        @metadata_service = ::DocTemplate
                              .config.dig('metadata', 'service').constantize
                              .parse(@content, material: material?)

        ::DocTemplate.context_types.each do |context_type|
          options = @metadata_service.options_for context_type
          @documents[context_type] = ::DocTemplate::Document.parse(@content.dup, options)
          @documents[context_type].parts << {
            content: render(options),
            context_type: context_type,
            data: {},
            materials: [],
            optional: false,
            part_type: :layout,
            placeholder: nil
          }

          @toc ||= ::DocTemplate::DocumentTOC.parse(options) unless material?
        end

        self
      end

      def parts
        @documents.values.flat_map(&:parts)
      end

      def prereq?
        metadata['type'].to_s.casecmp('prereq').zero?
      end

      def remove_part(type, context_type)
        result = nil
        @documents.each_key do |k|
          result = @documents[k].parts.detect { |p| p[:part_type] == type && p[:context_type] == context_type }
          @documents[k].parts.delete(result) && break if result.present?
        end
        result
      end

      def render(options = {})
        type = options.fetch(:context_type, ::DocTemplate.context_types.first)
        DocTemplate.sanitizer.post_processing(@documents[type]&.render.presence || '', options)
      end

      module ClassMethods
        def parse(source, type: :document)
          new(type).parse(source)
        end

        def register_tag(name, klass)
          key = name.is_a?(Regexp) ? name : name.to_s
          tags[key] = klass
        end

        def tags
          @tags ||= TagRegistry.new
        end
      end
    end
  end
end
