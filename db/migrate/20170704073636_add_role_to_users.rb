# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :role, :integer, default: 0, null: false
  end

  def data
    User.where(admin: true).update_all(role: 1)
  end
end
