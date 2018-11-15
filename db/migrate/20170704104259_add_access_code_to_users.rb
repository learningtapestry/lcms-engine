# frozen_string_literal: true

class AddAccessCodeToUsers < Lcms::Engine::Migration
  def change
    add_column :users, :access_code, :string
  end
end
