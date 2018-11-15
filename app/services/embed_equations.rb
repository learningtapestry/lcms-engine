# frozen_string_literal: true

class EmbedEquations
  REDIS_KEY = 'ub-equation:'
  REDIS_KEY_SVG = "#{REDIS_KEY}svg:"

  class << self
    def call(content)
      frag = Nokogiri::HTML.fragment(content)

      frag.css('img').each do |img|
        tex = fetch_tex img[:src]
        html = tex_to_html tex
        next unless (equation_node = Nokogiri::HTML.fragment(html).at_css('span'))

        img.replace(equation_node)
      end

      frag.to_s
    end

    def tex_to_html(tex)
      return if tex.blank?

      if (html = redis.get("#{REDIS_KEY}#{tex}")).blank?
        html = `tex2html -- '#{tex}'`
        redis.set "#{REDIS_KEY}#{tex}", html
      end

      html
    end

    def tex_to_svg(tex, custom_color: nil, preserve_color: false)
      return if tex.blank?

      key = "#{REDIS_KEY_SVG}#{tex}#{preserve_color}#{custom_color}"
      if (svg = redis.get(key)).blank?
        tex = "\\require{color}\\definecolor{math}{RGB}{#{custom_color}}\\color{math}{#{tex}}" if custom_color.present?
        svg = `tex2svg -- '#{tex}'`

        #
        # Should make that change only for Web view.
        # Settings color to `initial` prevents it from customization
        #
        svg = fix_color(svg, preserve_color) unless custom_color.present?

        redis.set key, svg
      end

      svg
    end

    private

    def fetch_tex(url)
      uri = URI.parse(url)
      params = Rack::Utils.parse_nested_query(uri.query)
      return unless params['cht'] == 'tx'

      params['chl']
    end

    def fix_color(svg, preserve)
      value = preserve ? 'currentColor' : 'initial'
      source = Nokogiri::XML.parse svg
      source.css('g').attr('fill', value)
      source.css('g').attr('stroke', value)
      source.root.to_s
    end

    def redis
      Rails.application.config.redis
    end
  end
end
