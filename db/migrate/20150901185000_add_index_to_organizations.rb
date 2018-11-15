# frozen_string_literal: true

class AddIndexToOrganizations < Lcms::Engine::Migration
  def change
    add_index :organizations, :name, unique: true
  end
end
