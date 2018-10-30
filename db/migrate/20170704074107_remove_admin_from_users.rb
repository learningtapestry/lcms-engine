# frozen_string_literal: true

class RemoveAdminFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :admin, :boolean, default: true, null: false
  end

  def rollback
    User.where(role: 0).update_all(admin: false)
  end
end
