# frozen_string_literal: true

class AddNewStandardFields < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :course, :string
    add_column :standards, :domain, :string
    add_column :standards, :emphasis, :string
    add_column :standards, :strand, :string
    add_column :standards, :synonyms, :text, array: true, default: []
  end
end
