# frozen_string_literal: true

class CreateLcmsEngineIntegrationsWebhookConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :lcms_engine_integrations_webhook_configurations do |t|
      t.string :event_name, null: false, index: { name: 'index_webhook_configurations_on_event_name' }
      t.boolean :active, default: true, null: false

      t.string :endpoint_url, null: false
      t.string :action, null: false, default: 'post'

      t.string :auth_type
      t.jsonb  :auth_credentials

      t.timestamps
    end
  end
end
