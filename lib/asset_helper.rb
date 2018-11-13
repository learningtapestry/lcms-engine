# frozen_string_literal: true

class AssetHelper
  REDIS_PREFIX = 'ub-b64-asset'

  class << self
    def base64_encoded(path, cache: false)
      key = "#{REDIS_PREFIX}#{path}"

      if cache
        b64_asset = redis.get(key)
        return b64_asset if b64_asset.present?
      end

      b64_asset = encode path
      redis.set key, b64_asset, ex: 1.day.to_i if cache
      b64_asset
    end

    def inlined(path)
      if Rails.env.development? || Rails.env.test?
        asset = Rails.application.assets.find_asset(path)
      else
        filesystem_path = Rails.application.assets_manifest.assets[path]
        asset = File.read(Rails.root.join('public', 'assets', filesystem_path))
      end
      asset
    end

    private

    def encode(path)
      if Rails.env.development? || Rails.env.test?
        asset = Rails.application.assets.find_asset(path)
        content_type = asset&.content_type
      elsif (filesystem_path = Rails.application.assets_manifest.assets[path])
        asset = File.read(Rails.root.join('public', 'assets', filesystem_path))
        content_type = Mime::Type.lookup_by_extension(File.extname(path).split('.').last)
      end
      raise "Could not find asset '#{path}'" if asset.nil?
      raise "Unknown MimeType for asset '#{path}'" if content_type.nil?

      encoded = Base64.encode64(asset.to_s).gsub(/\s+/, '')
      "data:#{content_type};base64,#{Rack::Utils.escape(encoded)}"
    end

    def redis
      Rails.application.config.redis
    end
  end
end
