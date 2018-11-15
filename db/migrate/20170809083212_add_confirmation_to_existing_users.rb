# frozen_string_literal: true

class AddConfirmationToExistingUsers < Lcms::Engine::Migration
  def data
    User.find_each(&:confirm)
  end
end
