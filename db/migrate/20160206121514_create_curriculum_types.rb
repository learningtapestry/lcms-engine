# frozen_string_literal: true

class CreateCurriculumTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :curriculum_types do |t|
      t.string :name, null: false
    end
  end
end
