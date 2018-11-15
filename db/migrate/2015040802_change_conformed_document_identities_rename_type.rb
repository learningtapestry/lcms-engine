# frozen_string_literal: true

class ChangeConformedDocumentIdentitiesRenameType < Lcms::Engine::Migration
  def change
    rename_column :conformed_document_identities, :type, :identity_type
  end
end
