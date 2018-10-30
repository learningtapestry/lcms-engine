# frozen_string_literal: true

class ChangeLearningObjectIdentitiesRenameType < ActiveRecord::Migration[4.2]
  def change
    rename_column :learning_object_identities, :type, :identity_type
  end
end
