# frozen_string_literal: true

require 'base64'

class SketchCompiler
  def initialize(user_id, user_ip, version)
    @user_id = user_id
    @user_ip = user_ip
    @version = version
  end

  #
  # Returns HTTParty::Response object
  #
  def compile(core_url, foundational_url)
    api_url = ENV.fetch('UB_COMPONENTS_API_URL')
    url = [api_url, @version, 'compile'].join('/')
    post_params = {
      body: {
        uid: Base64.encode64("#{@user_id}@#{@user_ip}"),
        url: core_url,
        foundational_url: foundational_url
      },
      headers: { 'Authorization' => %(Token token="#{ENV.fetch 'UB_COMPONENTS_API_TOKEN'}") },
      timeout: 5 * 60
    }
    HTTParty.post url, post_params
  end
end
