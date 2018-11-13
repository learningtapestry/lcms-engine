# frozen_string_literal: true

module DocumentDownloader
  class Gdoc < DocumentDownloader::Base
    GOOGLE_DRAWING_RE = %r{https?://docs\.google\.com/?[^"]*/drawings/[^"]*}i
    MIME_TYPE = 'application/vnd.google-apps.document'
    RETRY_DELAYES = [10.seconds, 30.seconds, 45.seconds, 1.minute, 3.minutes].freeze
    MAX_RETRY_COUNT = RETRY_DELAYES.size

    def self.gdoc_file_url(id)
      "https://docs.google.com/document/d/#{id}"
    end

    def initialize(credentials, file_url, opts = {})
      super
      @options = opts
    end

    def download
      retry_attempt ||= 0
      html = service
               .export_file(file_id, 'text/html')
               .encode('ASCII-8BIT')
               .force_encoding('UTF-8')
      @content = handle_google_drawings(html)
      self
    rescue Google::Apis::RateLimitError
      raise unless options[:import_retry]
      raise if retry_attempt >= MAX_RETRY_COUNT

      sleep RETRY_DELAYES[retry_attempt] * rand(1.0..5.0)
      retry_attempt += 1
      retry
    end

    private

    attr_reader :options

    def handle_google_drawings(html)
      return html unless (match = html.scan(GOOGLE_DRAWING_RE))

      headers = { 'Authorization' => "Bearer #{@credentials.access_token}" }

      match.to_a.uniq.each do |url|
        response = HTTParty.get CGI.unescapeHTML(url), headers: headers
        new_src = "data:#{response.content_type};base64, #{Base64.encode64(response)}\" drawing_url=\"#{url}"
        html = html.gsub(url, new_src)
      end

      html
    end
  end
end
