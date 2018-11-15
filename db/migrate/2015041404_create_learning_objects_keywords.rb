# frozen_string_literal: true

class CreateLearningObjectsKeywords < Lcms::Engine::Migration
  def change
    create_table :learning_objects_keywords do |t|
      t.references :learning_object, references: :learning_objects
      t.references :keyword, references: :keywords

      t.timestamps
    end
  end
end
