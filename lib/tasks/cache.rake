# frozen_string_literal: true

namespace :cache do
  desc 'Clears up Rails cache store'
  task(clear: [:environment]) { Rails.cache.clear }

  desc 'Reset Base64 cached assets'
  task reset_base64: :environment do
    redis = Rails.application.config.redis
    redis.keys("#{AssetHelper::REDIS_PREFIX}*").each { |key| redis.del key }
  end
end
