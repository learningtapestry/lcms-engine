# frozen_string_literal: true

require 'rails_helper'

feature 'Login/logout functionality' do
  given(:email) { Faker::Internet.email }
  given(:password) { Faker::Internet.password }
  given!(:admin) { create :admin, email:, password:, password_confirmation: password }

  scenario 'login' do
    visit lcms_engine.admin_path
    expect(current_path).to eq lcms_engine.new_user_session_path

    fill_in 'email-field', with: email
    fill_in 'password-field', with: password
    click_on 'Log in'
    expect(current_path).to eq lcms_engine.admin_path
  end

  scenario 'logout' do
    login_as admin, scope: :user

    visit lcms_engine.admin_path
    find(:xpath, "//a[@href='#{lcms_engine.destroy_user_session_path}']").click
    expect(current_path).to eq lcms_engine.new_user_session_path
  end
end
