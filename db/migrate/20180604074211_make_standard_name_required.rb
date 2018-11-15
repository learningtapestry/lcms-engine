# frozen_string_literal: true

class MakeStandardNameRequired < Lcms::Engine::Migration
  def up
    execute "UPDATE standards SET name = 'name' WHERE name is null;"
    change_column :standards, :name, :string, null: false
    change_column :standards, :subject, :string, null: true
  end

  def down; end
end
