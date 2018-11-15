# frozen_string_literal: true

class ChangeLearningObjectIdentitiesRenameType < Lcms::Engine::Migration
  def change
    rename_column :learning_object_identities, :type, :identity_type
  end
end
