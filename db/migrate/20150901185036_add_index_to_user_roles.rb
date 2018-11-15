# frozen_string_literal: true

class AddIndexToUserRoles < Lcms::Engine::Migration
  def change
    add_index :user_roles, %i(user_id organization_id role_id), unique: true
  end
end
