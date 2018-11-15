# frozen_string_literal: true

class AddAdminToUsers < Lcms::Engine::Migration
  def change
    add_column :users, :admin, :boolean, null: false, default: true
  end
end
