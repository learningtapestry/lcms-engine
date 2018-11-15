# frozen_string_literal: true

class CreateLearningObjectAgeRanges < Lcms::Engine::Migration
  def change
    create_table :learning_object_age_ranges do |t|
      t.references :learning_object, references: :learning_objects
      t.integer :age
      t.boolean :min_age

      t.timestamps
    end
  end
end
