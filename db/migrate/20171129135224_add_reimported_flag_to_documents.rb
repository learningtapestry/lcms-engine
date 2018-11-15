# frozen_string_literal: true

class AddReimportedFlagToDocuments < Lcms::Engine::Migration
  def change
    add_column :documents, :reimported, :boolean, default: true, null: false
  end
end
