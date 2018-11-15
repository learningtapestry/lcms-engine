# frozen_string_literal: true

class CreateRoles < Lcms::Engine::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :description
    end
  end
end
