# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # NOTE: remove with reverting confiramble on, need this not to sign in user after sign up
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      set_flash_message :notice, :signed_up
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def after_inactive_sign_up_path_for(_resource)
    new_user_session_path
  end
end
