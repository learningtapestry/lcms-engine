# frozen_string_literal: true

class ChangeConformedDocumentIdentitiesRenameType < ActiveRecord::Migration[4.2]
  def change
    rename_column :conformed_document_identities, :type, :identity_type
  end
end
