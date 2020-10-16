# frozen_string_literal: true

require 'sanitize'

module Lcms
  module Engine
    class HtmlSanitizer # rubocop:disable Metrics/ClassLength
      LIST_STYLE_RE = /\.lst-(\S+)[^{}]+>\s*(?:li:before)\s*{\s*content[^{}]+counter\(lst-ctn-\1,([^)]+)\)/.freeze
      CLEAN_ELEMENTS = %w(a div h1 h2 h3 h4 h5 h6 p table).join(',')
      GDOC_REMOVE_EMPTY_SELECTOR = '.o-ld-activity'
      LINK_UNDERLINE_REGEX = /text-decoration\s*:\s*underline/i.freeze
      SKIP_P_CHECK = %w(ul ol table).freeze
      STRIP_ELEMENTS = %w(a div h1 h2 h3 h4 h5 h6 p span table text).freeze

      class << self
        def clean_content(html, context_type)
          return html unless context_type.to_s.casecmp('gdoc').zero?

          nodes = Nokogiri::HTML.fragment html
          clean_double_margin_elements(nodes)
          clean_empty_elements(nodes.elements)
          clean_dropdowns(nodes)
          nodes.to_html.strip
        end

        def sanitize(html)
          Sanitize.fragment(html, default_config)
        end

        def sanitize_css(css)
          Sanitize::CSS.stylesheet(css, css_config)
        end

        #
        # Removes all empty nodes before first one filled in
        #
        def strip_content(nodes)
          nodes.children.each do |node|
            break if keep_node?(node)

            node.remove
          end
        end

        def strip_html(html)
          return '' if html.blank?

          nodes = Nokogiri::HTML.fragment html
          strip_content(nodes)
          nodes.to_html || ''
        end

        def strip_html_element(element)
          return '' if element.blank? || Sanitize.fragment(element, elements: []).strip.empty?

          element
        end

        def post_processing(html, options)
          @options = options
          nodes = Nokogiri::HTML.fragment html

          post_processing_hr(nodes) if options[:material]
          return post_processing_gdoc(nodes) if options[:context_type].to_s.casecmp('gdoc').zero?

          post_processing_default(nodes)
        end

        def process_list_styles(html)
          html.xpath('//style').each do |stylesheet|
            stylesheet.text.scan(LIST_STYLE_RE) do |match|
              list_selector = "ol.lst-#{match[0]}"
              counter_type = match[1]
              html.css(list_selector).each do |element|
                element['style'] = [element['style'], "list-style-type: #{counter_type}"].join(';')
              end
            end
          end
          html
        end

        #
        # Config to keep list-style-type bc gdoc is doing this trough content/counter
        #
        def css_config
          {
            css: {
              properties: %w(content counter-increment counter-reset counter-set list-style-type)
            }
          }
        end

        #
        # List of attributes we need to keep when all parsing jobs have been completed
        #
        def css_inline_config
          {
            css: {
              properties: %w(font-style font-weight text-decoration)
            }
          }
        end

        def default_config
          {
            elements: %w(table td th tr tbody thead span a p h1 h2 h3 h4 h5 h6 ol ul li div img hr abbr b blockquote br
                         cite code dd dfn dl dt em i kbd mark pre q s samp small strike strong sub sup time u var),
            attributes: {
              'a' => %w(href title data-toggle id),
              'div' => %w(data-json-field data-json-type),
              'img' => %w(alt src style drawing_url),
              'ol' => %w(type style start list-style-type),
              'ul' => %w(type style start list-style-type),
              'li' => %w(class),
              'p' => %w(class style),
              'span' => %w(style),
              'sub' => %w(style),
              'sup' => %w(style),
              'td' => %w(colspan rowspan style),
              'th' => %w(colspan rowspan),
              'tr' => %w(style)
            },
            protocols: {
              'a' => { 'href' => ['http', 'https', :relative] }
            },
            css: {
              properties: %w(background-color border-bottom-width border-left-width border-right-width border-top-width
                             border-bottom border-left border-right border-top height font-style font-weight
                             list-style-type text-align text-decoration vertical-align width)
            },
            transformers: [ # These transformers Will be executed via .call(), as lambdas
              method(:remove_meanless_styles),
              method(:remove_empty_paragraphs),
              # TODO: need to change parsing tags xpath before, it's relying on spans
              # method(:remove_spans_wo_attrs)
              method(:remove_gdocs_pagebreaks),
              method(:remove_gdocs_suggestions),
              method(:replace_charts_urls),
              method(:replace_supsub),
              method(:keep_bullets_level),
              method(:replace_table_border_styles)
            ]
          }
        end

        protected

        def post_clean_styles(nodes)
          %w(p span sub sup).each do |tag|
            nodes.xpath(".//#{tag}").each do |node|
              next if node.ancestors('td').present?

              # do not sanitize Mathjax elements
              if node['class']&.index('mjx').nil?
                node['style'] = Sanitize::CSS.properties(node['style'], css_inline_config)
              end
              node.delete('style') if node['style'].blank?
            end
          end
        end

        private

        FONT_STYLES_RE = [
          /font-weight:\s*(normal|[1-4]00);?/,
          /font-style:\s*normal;?/,
          /text-decoration:\s*none;?/,
          /(^|;)\s*color:#000000/
        ].freeze
        private_constant :FONT_STYLES_RE

        BORDER_RE = /border-\w+-width:\s*0\w+;?/.freeze
        private_constant :BORDER_RE

        BORDER_REPLACE_RE = {
          bottom: /border-bottom-width:\s*0\w+;?\s*/i,
          left: /border-left-width:\s*0\w+;?\s*/i,
          right: /border-right-width:\s*0\w+;?\s*/i,
          top: /border-top-width:\s*0\w+;?\s*/i
        }.freeze
        private_constant :BORDER_REPLACE_RE

        SUB_SUP_RE = [
          { el: 'sub', re: ".//span[case_regular(@style, 'vertical-align:\\s*sub;?')]" },
          { el: 'sup', re: ".//span[case_regular(@style, 'vertical-align:\\s*super;?')]" }
        ].freeze
        private_constant :SUB_SUP_RE

        SUB_SUP_STYLE_RE = /vertical-align:\s*(sub|super);?/i.freeze
        private_constant :SUB_SUP_STYLE_RE

        def add_css_class(el, *classes)
          existing = (el[:class] || '').split(/\s+/)
          el[:class] = existing.concat(classes).uniq.join(' ')
        end

        def clean_double_margin_elements(nodes)
          nodes.css('p:not(.do-not-strip):empty + div, p:not(.do-not-strip):empty + table').each do |node|
            node.previous_element.remove
          end
        end

        def clean_dropdowns(nodes)
          nodes.css('.o-ld-dropdown').each(&:remove)
        end

        def clean_empty_elements(nodes)
          return unless nodes.present?

          prev_skip = false
          prev_p = false
          nodes.each_with_index do |node, idx|
            clean_empty_elements(node.elements)
            if keep_node?(node)
              prev_skip = false
              prev_p = node.name == 'p' ||
                       (SKIP_P_CHECK.exclude?(node.name) && node.xpath('.//*').any? { |el| el.name == 'p' })
              next
            end
            node.remove if prev_skip || prev_p || idx.zero?
            prev_skip = true
          end
        end

        def fix_external_target(node)
          return unless node['href'] =~ /\Awww|http/i

          node['target'] = '_blank'
          return unless (span = node.parent)&.name == 'span'

          # remove excessive text-decoration
          span['style'] = (span['style'] || '').sub(LINK_UNDERLINE_REGEX, '')
        end

        def fix_inline_img(node)
          # TODO: test if it's working fine with all inline images
          node['src'] = node['src'].gsub!(/%(20|0A)/, '') if node['src'].to_s.start_with?('data:')
        end

        def fix_googlechart_img(node)
          add_css_class(node, 'o-google-chart') if node['src'] =~ /chart\.googleapis/i
        end

        def fix_table_styles(nodes, param, selector)
          attr_regex = /(^|;\s*)#{param}\s*:\s*([\w.]+)\s*($|;)*/
          nodes.css(selector).each do |node|
            node[param] = node['style'].match(attr_regex)&.[](2)
          end
        end

        def keep_bullets_level(env)
          node = env[:node]
          return unless node.element? && node.name == 'li' && node['style'].to_s.include?('margin-left')

          indent = /margin-left\s*:\s*(\d+)/.match(node['style']).try(:[], 1).to_i
          add_css_class(node, "u-ld-indent--l#{(indent - 50) / 30 + 2}") if indent >= 50
        end

        def post_processing_default(nodes)
          post_processing_base(nodes)
          if @options[:metadata].try(:subject).to_s.casecmp('math').zero?
            # wrap all images for math except those inside table
            # handle images that should be cropped
            post_processing_images(nodes)

            # Removes empty tags between activity and activity-sources
            nodes.css('.o-ld-activity.c-ld-toc + p:empty').each(&:remove)
            nodes.css('.o-ld-activity.c-ld-toc + h4:empty').each(&:remove)
          end
          post_processing_tables(nodes)
          nodes.to_html
        end

        def post_processing_gdoc(nodes)
          post_processing_base(nodes)
          # TODO: comment for now bc direct link to google drawing stopped to work after 15/08
          # post_processing_drawings(nodes)
          post_processing_images_gdoc(nodes) if @options[:metadata]&.subject.to_s.casecmp('math').zero?
          post_processing_tables_gdoc(nodes)

          # add class to google charts
          nodes.css('img[src]').each(&method(:fix_googlechart_img))
          # add class to empty paragraphs to remove padding-bottom
          nodes.css('p:not(.u-gdoc-gap):empty').add_class('u-gdoc-empty-p')
          nodes.to_html
        end

        def post_processing_base(nodes)
          # removes all style attributes allowed earlier
          post_clean_styles(nodes)

          # adjusts `class` attributes for all `ol` elements inside tables
          nodes.xpath('.//table//ol').each { |ol| ol['class'] = 'c-ld-ol' }

          strip_content(nodes)

          # fix inlined images
          nodes.css('img[src]').each(&method(:fix_inline_img))

          # add target blank to external links
          nodes.css('a:not([target="_blank"])').each(&method(:fix_external_target))
        end

        def post_processing_drawings(nodes)
          nodes.css('img[drawing_url]').each do |node|
            node['src'] = node['drawing_url']
          end
        end

        def post_processing_images(nodes)
          nodes
            .xpath('//table//img/..')
            .add_class('u-ld-not-image-wrap')

          return if @options[:material]

          nodes
            .css(':not(.u-ld-not-image-wrap) > img:not([src*=googleapis])')
            .wrap('<div class="o-ld-image-wrap--math u-text--centered"></div>')

          nodes
            .css('.o-ld-image-student-worksheet')
            .wrap('<div class="o-ld-image-wrap--math"></div>')
        end

        def post_processing_images_gdoc(nodes)
          return if @options[:material]

          nodes
            .xpath('//table//img/..')
            .add_class('u-ld-not-image-wrap')

          css = ':not(.u-ld-not-image-wrap) > img:not([src*=googleapis]):not(.o-ld-icon):not(.o-ld-latex)'
          nodes.css(css).each do |img|
            img = img.parent.replace(img) if img.parent.name == 'span' || img.parent.name == 'p'
            img.replace(%(
          <table class='o-simple-table o-ld-image-wrap--math'>
            <tr>
              <td class="o-ld-image-wrap__img u-gdoc-margin-vertical--small u-gdoc-padding-vertical--small">
                <div class="u-text--centered">
                  #{img}
                </div>
              </td>
            </tr>
          </table>
          <p class="do-not-strip"></p>
        ))
          end
        end

        def post_processing_hr(nodes)
          nodes.css('hr').each(&:remove)
        end

        # add style to table for consistent view
        # wrap for horizontal scrolling on small screens
        def post_processing_tables(nodes)
          tables = nodes
                     .css('table:not(.o-ld-columns-table)')
                     .add_class('c-ld-table')
          tables.wrap('<div class="c-ld-table__wrap"></div>') unless @options[:material]
        end

        def post_processing_tables_gdoc(nodes)
          # NOTE: not sure that we need this, sometimes it's working with width/from the style
          fix_table_styles(nodes, 'width', 'table td[style*=width]')
          fix_table_styles(nodes, 'height', 'table tr[style*=height]')
          nodes.css('table:not(.o-simple-table) td, table:not(.o-simple-table) th').add_class('u-table-padding')
          nodes.css('table:not(.o-simple-table)').add_class('o-native-table')
        end

        # Replace '<span>text</span>' with 'text'
        def remove_spans_wo_attrs(env)
          node = env[:node]

          node.replace(node.inner_html) if node.element? && node.name == 'span' && node.attr('style').blank?
        end

        # Remove '<p></p>' or '<span></span>'
        def remove_empty_paragraphs(env)
          node = env[:node]

          node.unlink if node.element? && (node.name == 'p' || node.name == 'span') && node.inner_html.squish.blank?
        end

        # replace inline borders style with width = 0 as they're not processing correct for pdf
        def replace_table_border_styles(env)
          node = env[:node]
          return unless node.element? && node.name == 'table'

          node.xpath('tbody/tr/td').each do |el|
            next unless el[:style] =~ BORDER_RE

            %i(bottom left right top).each do |b|
              el[:style] = el[:style].gsub(BORDER_REPLACE_RE[b], "border-#{b}:0;")
            end
          end
        end

        def remove_meanless_styles(env)
          node = env[:node]
          return unless node.element?
          return unless node.attr('style').present?

          node['style'] = FONT_STYLES_RE.reduce(node['style'].to_s) { |res, re| res.gsub re, '' }
        end

        def remove_gdocs_pagebreaks(env)
          env[:node].css('hr[style*=page-break]').each(&:remove)
        end

        def remove_gdocs_suggestions(env)
          node = env[:node]
          node.css('[id^=cmnt]').each do |a|
            a.ancestors('sup').first.remove
          rescue StandardError
            a.ancestors('div').first.remove
          end
        end

        def replace_charts_urls(env)
          node = env[:node]
          node.css('img[src^="https://www.google.com/chart"]').each do |img|
            img[:src] = img[:src].gsub('www.google', 'chart.googleapis')
          end
        end

        def replace_supsub(env)
          node = env[:node]
          SUB_SUP_RE.each do |rule|
            node.xpath(rule[:re], DocTemplate::XpathFunctions.new).each do |el|
              el[:style] = el[:style].sub(SUB_SUP_STYLE_RE, '')
              el.replace el.to_s.gsub('<span', "<#{rule[:el]}").gsub('span>', "#{rule[:el]}>")
            end
          end
        end

        def keep_node?(node)
          return true if node.inner_text.squish.present?
          return true if STRIP_ELEMENTS.exclude?(node.name)
          return true if node['class'].to_s.include?('do-not-strip')

          node.xpath('.//*').any? { |el| STRIP_ELEMENTS.exclude?(el.name) || el['href'] }
        end
      end
    end
  end
end
