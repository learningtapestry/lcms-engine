# frozen_string_literal: true

class ChangeLearningObjectIdentitiesAddCanonical < Lcms::Engine::Migration
  def change
    change_table :learning_object_identities do |t|
      t.references :canonical, references: :learning_object_identities
    end

    add_index :learning_object_identities, :canonical_id
  end
end
