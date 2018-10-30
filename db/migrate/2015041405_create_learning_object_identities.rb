# frozen_string_literal: true

class CreateLearningObjectIdentities < ActiveRecord::Migration[4.2]
  def change
    create_table :learning_object_identities do |t|
      t.references :learning_object, references: :learning_objects
      t.references :identity, references: :identities
      t.integer :type

      t.timestamps
    end
  end
end
