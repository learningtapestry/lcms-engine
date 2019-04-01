# frozen_string_literal: true

require 'rails_helper'

feature 'Admin users' do
  include EmailSpec::Helpers

  given(:access_code) { create(:access_code).code }
  given(:admin) { create :admin }
  given(:domain) { ENV['APPLICATION_DOMAIN'] }
  given!(:user) { create :user, email: "unbounded@#{domain}" }
  given(:name) { Faker::Lorem.name }
  given(:email) { Faker::Internet.email }
  given(:reset_msg) { 'You will receive an email with instructions on how to reset your password in a few minutes. ×' }

  background { login_as admin }

  scenario 'new user with blank email' do
    navigate_to_new_user

    click_button 'Save'
    expect(page.all('.input.error .error').first.text).to eq "can't be blank"
  end

  scenario 'new user' do
    navigate_to_new_user

    fill_in 'Access code', with: access_code
    fill_in 'Name', with: name
    fill_in 'Email', with: email
    click_button 'Save'

    last_user = Lcms::Engine::User.last
    expect(last_user.name).to eq name
    expect(last_user.email).to eq email
    expect(current_path).to eq lcms_engine.admin_users_path
    expect_reset_password_email_for last_user
  end

  scenario 'edit user with blank email' do
    navigate_to_edit_user

    fill_in 'Email', with: ''
    click_button 'Save'

    user.reload
    expect(current_path).to eq lcms_engine.admin_user_path(user.id)
    expect(page.find('.input.error .error').text).to eq "can't be blank"
    expect(user.email).to eq "unbounded@#{domain}"
  end

  scenario 'edit user' do
    navigate_to_edit_user

    fill_in 'Email', with: "joe@#{domain}"
    fill_in 'Name', with: 'Joe Jonah'
    click_button 'Save'

    user.reload
    expect(current_path).to eq lcms_engine.edit_admin_user_path(user.id)
    expect(page.find('.callout.success').text).to include('saved successfully')
    expect(user.email).to eq "unbounded@#{domain}"
    expect(user.unconfirmed_email).to eq "joe@#{domain}"
    expect(user.name).to eq 'Joe Jonah'
  end

  scenario 'delete user' do
    visit lcms_engine.admin_users_path

    within "#user_#{user.id}" do
      click_button 'Delete'
    end

    expect(current_path).to eq lcms_engine.admin_users_path
    expect(page.find('.callout.success').text).to include('deleted successfully')
    expect(Lcms::Engine::User.find_by id: user.id).to be_nil
  end

  scenario 'reset user password' do
    visit lcms_engine.admin_users_path

    within "#user_#{user.id}" do
      click_button 'Reset password'
    end

    user.reload
    expect(current_path).to eq lcms_engine.admin_users_path
    expect(page.find('.callout.success').text).to include('will receive a password reset')
    expect(user.reset_password_token).to_not be_nil
    expect_reset_password_email_for user
  end

  scenario 'logged out password reset' do
    logout

    visit lcms_engine.new_user_session_path
    click_link 'Forgot your password?'
    expect(current_path).to eq lcms_engine.new_user_password_path

    fill_in 'user_email', with: admin.email
    click_button 'Send me reset password instructions'
    expect(current_path).to eq lcms_engine.new_user_session_path
    expect(find('.callout.success').text).to eq reset_msg
    expect_reset_password_email_for admin

    email = last_email_sent
    new_password_link = URI.extract(email.body.raw_source).first
    password = Faker::Internet.password
    visit new_password_link
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Change my password'

    expect(current_path).to eq lcms_engine.root_path
    expect(find('.callout.success').text).to eq 'Your password has been changed successfully. You are now signed in. ×'
    expect(admin.reload.valid_password?(password)).to be true
  end

  def navigate_to_new_user
    visit lcms_engine.admin_users_path
    click_link 'New user'
    expect(current_path).to eq lcms_engine.new_admin_user_path
  end

  def navigate_to_edit_user
    visit lcms_engine.admin_users_path
    click_link user.id
    expect(current_path).to eq lcms_engine.edit_admin_user_path(user.id)
  end

  def expect_reset_password_email_for(user)
    email = last_email_sent
    expect(email.from).to eq "no-reply@#{domain}"
    expect(email.subject).to eq 'Reset password instructions'
    expect(email.to).to include user.email
  end
end
