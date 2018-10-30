# frozen_string_literal: true

class CreateKeywords < ActiveRecord::Migration[4.2]
  def change
    create_table :keywords do |t|
      t.string  :name
      t.string  :source

      t.timestamps
    end

    add_index :keywords, :name
  end
end
