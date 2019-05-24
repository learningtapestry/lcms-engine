# frozen_string_literal: true

module DocTemplate
  module Tables
    class Base
      SPLIT_REGEX = /[,;\r\n]/

      attr_reader :data

      def self.parse(fragment, *args)
        new.parse(fragment, *args)
      end

      def initialize
        @data = {}
        @table_exists = false
      end

      def parse(fragment, *args)
        @options = args.extract_options!

        # get the table
        table = fragment.at_xpath("table//*[contains(., '#{self.class::HEADER_LABEL}')]")
        @table_exists = table.present?
        return self unless @table_exists

        table.search('br').each { |br| br.replace("\n") }
        @data = fetch table

        table.remove
        self
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
    end
  end
end
