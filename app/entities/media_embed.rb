# frozen_string_literal: true

class MediaEmbed
  SUBJECT_COLORS = { math: '00a699', ela: 'f75b28', default: 'a269bf' }.freeze

  def self.soundcloud(url, subject)
    color = SUBJECT_COLORS[subject || :default]
    oembed_url = "http://soundcloud.com/oembed?url=#{url}&iframe=true&maxheight=166&" \
                 "color=#{color}&auto_play=false&format=json"
    RestClient.get(oembed_url) do |response|
      if response.code == 200
        oembed = JSON.parse(response)['html']
        return oembed.sub!('visual=true&', '') if oembed.present?
      end
    end
    nil
  end

  def self.video_id(url)
    case url
    when /youtube/
      query = URI(url).query
      Rack::Utils.parse_query(query)['v']
    when /vimeo\.com/
      url.match(%r{https?://(www\.)?vimeo.com/(\d+)}).try(:[], 2)
    when /youtu\.be/
      url.match(%r{https?://(www\.)?youtu\.be/([^"&?\/]+)}).try(:[], 2)
    end
  end
end
