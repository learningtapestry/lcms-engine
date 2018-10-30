# frozen_string_literal: true

class ConfirmAllExistingUsers < ActiveRecord::Migration[4.2]
  def data
    User.admin.update_all(confirmed_at: Time.current)
  end
end
