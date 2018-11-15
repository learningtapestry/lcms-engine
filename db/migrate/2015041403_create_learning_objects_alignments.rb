# frozen_string_literal: true

class CreateLearningObjectsAlignments < Lcms::Engine::Migration
  def change
    create_table :learning_objects_alignments do |t|
      t.references :learning_object, references: :learning_objects
      t.references :alignment, references: :alignments

      t.timestamps
    end
  end
end
