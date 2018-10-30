# frozen_string_literal: true

class CreateUserRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :user_roles do |t|
      t.references :user, index: true, foreign_key: true
      t.references :role, index: true, foreign_key: true
      t.references :organization, index: true, foreign_key: true
    end
  end
end
