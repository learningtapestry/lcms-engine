# frozen_string_literal: true

module DocTemplate
  module Tables
    class Target < Base
      HEADER_LABEL_PIECE = 'Long-Term Targets Addressed'
      TEMPLATE = 'target-table.html.erb'

      def parse(fragment, _template_type)
        path = ".//table/*/tr[1]/td[1][case_insensitive_contains(.//*/text(), '#{HEADER_LABEL_PIECE}')]"
        return unless (element = fragment.at_xpath path, XpathFunctions.new)
        return unless (table = element.ancestors('table').first)

        @target_data = fetch table

        template = File.read DocTemplate::Tags::BaseTag.template_path_for(TEMPLATE)
        content = ERB.new(template).result(binding).squish
        content = DocTemplate::Document.parse Nokogiri::HTML.fragment(content)

        # remove next element if it's empty paragraph
        # (quick fix before refactoring at https://github.com/learningtapestry/unbounded/issues/780)
        el_next = table.next_element
        el_next.remove if el_next&.name == 'p' && el_next.content.blank?

        table.replace content.render
        content
      end

      private

      def fetch(table)
        data = {}.tap do |result|
          # Need to handle every `p` and `ul` elements
          result[:long_term_title] = table.xpath('*//tr[1]/td').map(&:content).join(' ')
          result[:long_term] = table.xpath('*//tr[2]/td/p').map(&:content).join('; ')
          result[:long_term] += table.xpath('*//tr[3]/td/ul/li').map(&:content).join('; ')

          result[:short_term] = table.xpath('*//tr[4]/td[1]/p').map(&:content).join('; ')
          result[:short_term] += table.xpath('*//tr[4]/td[1]/ul/li').map(&:content).join('; ')

          result[:assessment] = table.xpath('*//tr[4]/td[2]/p').map(&:content).join('; ')
          result[:assessment] += table.xpath('*//tr[4]/td[2]/ul/li').map(&:content).join('; ')
        end

        # Wraps all tags into spans to keep consistence with the parser
        data.each_key { |key| data[key] = data[key].gsub('[', '<span>[').gsub(']', ']</span>') }
        data
      end
    end
  end
end
