# frozen_string_literal: true

FactoryBot.define do
  factory :webhook_configuration, class: Lcms::Engine::Integrations::WebhookConfiguration do
    event_name { 'event_name' }
    endpoint_url { 'http://example.com' }
    action { 'post' }
    auth_type { nil }
    auth_credentials { nil }

    trait :basic_auth do
      auth_type { 'basic' }
      auth_credentials { { username: 'username', password: 'password' } }
    end

    trait :bearer_auth do
      auth_type { 'bearer' }
      auth_credentials { { token: 'token' } }
    end

    trait :hmac_auth do
      auth_type { 'hmac' }
      auth_credentials { { secret_key: 'secret' } }
    end
  end
end
