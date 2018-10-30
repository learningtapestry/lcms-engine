# frozen_string_literal: true

class CreateResourceCurriculums < ActiveRecord::Migration[4.2]
  def change
    create_table :curriculums do |t|
      t.string :name, null: false, unique: true
      t.string :slug, null: false, unique: true

      t.timestamps null: false
    end
  end
end
