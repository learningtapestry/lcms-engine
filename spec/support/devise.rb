# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  # NOTE: Uncomment when we will migrate controller specs to request ones
  # config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Warden::Test::Helpers

  config.after :each do
    Warden.test_reset!
  end
end
