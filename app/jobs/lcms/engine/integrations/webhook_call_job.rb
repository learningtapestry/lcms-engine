# frozen_string_literal: true

module Lcms
  module Engine
    module Integrations
      class WebhookCallJob < Lcms::Engine::ApplicationJob
        extend ResqueJob
        include Lcms::Engine::RetryDelayed

        queue_as :low

        def perform(config_id, payload)
          webhook_configuration = WebhookConfiguration.find(config_id)

          webhook_configuration.execute_call(payload)
        end
      end
    end
  end
end
