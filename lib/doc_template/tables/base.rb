# frozen_string_literal: true

module DocTemplate
  module Tables
    class Base
      SPLIT_REGEX = /[,;\r\n]/

      attr_reader :errors, :data

      # @type method self.parse: (Nokogiri::HTML::DocumentFragment, ?(Integer | String, Hash[untyped, untyped])) -> self
      def self.parse(fragment, *)
        new.parse(fragment, *)
      end

      def self.flatten_table(table)
        return unless table.present?

        # remove blank tbody
        table.xpath('.//tbody').each { |tbody| tbody.remove if tbody.text.blank? }
        # move data from thead to tbody (first children)
        table.xpath('.//thead').each do |thead|
          tbody = table.at_xpath('.//tbody').presence || table.add_child('<tbody></tbody>').first
          thead.children.reverse.each { |child| tbody.prepend_child child }
          thead.remove
        end
        table
      end

      def initialize
        @data = {}
        @errors = []
        @table_exists = false
      end

      #
      # Inside each field in `fields` +Array+ splits the string by `separator` +String+ or
      # +RegExp+. Clean the each chunk and keep only clear fragment:
      # `<p><span>[tag]</span></p>`
      #
      # options:
      #   :skip_sanitize - to skip sanitization
      #   :separator - separator to split the input
      #   :keep_elements - +Array+ of HTML elements to keep during sanitizing
      #
      # Used when field contain only tags separated with separator. If there is any other
      # text content - use #parse_in_context
      #
      # @param data [Hash] resulting hash of #parse method
      # @param fields [Array] array of fields to clean tags in
      # @param opts [Hash] Additional options
      # @return modified `data` parameter
      #
      def collect_and_render_tags(data, fields, opts = {})
        fields.each do |field|
          (data[field] = []) && next if (row = data[field]).blank?

          tags = row
                   .split(opts[:separator].presence || SPLIT_REGEX)
                   .map(&:squish)
                   .reject(&:blank?)

          data[field] =
            tags.map do |tag|
              html = Nokogiri::HTML.fragment "<p><span>#{tag}</span></p>"
              parsed_html = DocTemplate::Document.parse(html).render.squish
              next parsed_html if opts.key?(:skip_sanitize)

              # NOTE: Allow HTML tags which present in the tag only
              keep = opts[:keep_elements] || []
              Sanitize.fragment(parsed_html, elements: keep)
            end
        end
        data
      end

      # @type method parse: (Nokogiri::HTML::DocumentFragment, ?(Integer | String, Hash[untyped, untyped])) -> self
      def parse(fragment, *args)
        @options = args.extract_options!

        # get the table
        table_key_cell = fragment.at_xpath("table//tr[1]/td[1][contains(., '#{self.class::HEADER_LABEL}')]")
        # flatten table to simple structure with tbody only
        table = self.class.flatten_table(table_key_cell&.ancestors('table')&.first)
        @table_exists = table.present?
        return self unless @table_exists

        table.search('br').each { |br| br.replace("\n") }
        @data = fetch table

        table.remove
        self
      end

      #
      # Update content of the field with parsed data
      # Generates nested +Hash+ for each of supported context types.
      #
      # Use case: In case when nested Tags should be parsed differently for different context
      # types we need explicitly specify each supported context type.
      #
      # @param content [String] HTML content to parse and render tags from
      # @param opts [Hash] Additional options
      # @return [Hash] nested Hash for each of supported context types
      #
      def parse_in_context(content, opts = {})
        # do not generate parts placeholder - inline all the tags
        opts[:explicit_render] = true
        html = Nokogiri::HTML.fragment content

        {}.tap do |result|
          ::DocTemplate.context_types.each do |context_type|
            opts[:context_type] = context_type
            rendered_content = DocTemplate::Document.parse(html.dup, opts).render
            result[context_type] = DocTemplate.sanitizer.post_processing(rendered_content, opts)
          end
        end
      end

      def fetch_materials(data, key)
        return data if (materials = data[key.to_s]).blank?

        data['material_ids'] =
          materials.split(SPLIT_REGEX).compact.map do |identifier|
            Lcms::Engine::Material.find_by(identifier: identifier.strip.downcase)&.id
          end.compact
        data
      end

      def table_exist?
        table_exists
      end

      protected

      attr_reader :options, :table_exists

      def fetch(table)
        {}.tap do |result|
          table.xpath('.//tr[position() > 1]').each do |row|
            key = row.at_xpath('./td[1]')&.text.to_s.squish.downcase
            next if key.blank?

            value = if self.class::HTML_VALUE_FIELDS.include? key
                      row.at_xpath('./td[2]').inner_html
                    else
                      row.at_xpath('./td[2]').text
                    end.squish

            result[key] = value
          end
        end
      end

      def xpath_meta_headers
        ".//table/*/tr[1]/td[1][case_insensitive_equals(normalize-space(),'#{self.class::HEADER_LABEL}')]"
      end
    end
  end
end
