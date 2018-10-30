# frozen_string_literal: true

class AddIndexToUserRoles < ActiveRecord::Migration[4.2]
  def change
    add_index :user_roles, %i(user_id organization_id role_id), unique: true
  end
end
