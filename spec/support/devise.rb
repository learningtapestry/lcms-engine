# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  # NOTE: Uncomment when we will migrate controller specs to request ones
  # config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Warden::Test::Helpers

  # This is needed to initiate routes loading for Devise,
  # as Rails 8 made routes loading lazy.
  config.before(:each) do
    Rails.application.routes_reloader.execute_unless_loaded
  end

  config.after :each do
    Warden.test_reset!
  end
end
