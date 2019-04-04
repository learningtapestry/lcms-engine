# frozen_string_literal: true

module FeatureHelper
  def sign_in(user)
    visit lcms_engine.new_user_session_path
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button 'Log in'
    expect(page).to have_no_link 'Log In'
  end

  def logout
    visit lcms_engine.destroy_user_session_path
  end
end

RSpec.configure do |config|
  config.include FeatureHelper, type: :feature
end
