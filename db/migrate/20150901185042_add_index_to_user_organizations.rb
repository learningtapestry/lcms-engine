# frozen_string_literal: true

class AddIndexToUserOrganizations < Lcms::Engine::Migration
  def change
    add_index :user_organizations, %i(user_id organization_id), unique: true
  end
end
