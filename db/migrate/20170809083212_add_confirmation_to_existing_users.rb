# frozen_string_literal: true

class AddConfirmationToExistingUsers < ActiveRecord::Migration[4.2]
  def data
    User.find_each(&:confirm)
  end
end
