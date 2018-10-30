# frozen_string_literal: true

class AddSlugToPages < ActiveRecord::Migration[4.2]
  def change
    add_column :pages, :slug, :string, null: false
  end
end
