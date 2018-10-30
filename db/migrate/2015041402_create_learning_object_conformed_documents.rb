# frozen_string_literal: true

class CreateLearningObjectConformedDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :learning_object_conformed_documents do |t|
      t.references :learning_object, references: :learning_objects
      t.references :conformed_document, references: :conformed_documents
      t.timestamps
    end
  end
end
