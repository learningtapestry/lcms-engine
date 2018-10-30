# frozen_string_literal: true

class AddIndexToUserOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_index :user_organizations, %i(user_id organization_id), unique: true
  end
end
