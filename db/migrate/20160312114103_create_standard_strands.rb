# frozen_string_literal: true

class CreateStandardStrands < ActiveRecord::Migration[4.2]
  def change
    create_table :standard_strands do |t|
      t.string :name, null: false
      t.string :heading
    end
  end
end
