# frozen_string_literal: true

class ConfirmAllExistingUsers < Lcms::Engine::Migration
  def data
    User.admin.update_all(confirmed_at: Time.current)
  end
end
