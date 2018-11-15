# frozen_string_literal: true

class ChangeSourceDocuments < Lcms::Engine::Migration
  def change
    change_table :engageny_documents do |t|
      t.references :source_document, index: true, foreign_key: true
    end

    change_table :lr_documents do |t|
      t.references :source_document, index: true, foreign_key: true
    end

    change_table :source_documents do |t|
      t.remove :source_id
      t.remove :source_type
      t.integer :source_type
    end

    add_index :source_documents, :source_type
  end
end
