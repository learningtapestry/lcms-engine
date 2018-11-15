# frozen_string_literal: true

class AddIndexToRoles < Lcms::Engine::Migration
  def change
    add_index :roles, :name, unique: true
  end
end
