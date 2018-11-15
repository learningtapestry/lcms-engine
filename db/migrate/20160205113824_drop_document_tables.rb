# frozen_string_literal: true

class DropDocumentTables < Lcms::Engine::Migration
  def change
    remove_column :lobject_age_ranges, :document_id
    remove_column :lobject_alignments, :document_id
    remove_column :lobject_descriptions, :document_id
    remove_column :lobject_downloads, :document_id
    remove_column :lobject_grades, :document_id
    remove_column :lobject_identities, :document_id
    remove_column :lobject_languages, :document_id
    remove_column :lobject_resource_types, :document_id
    remove_column :lobject_subjects, :document_id
    remove_column :lobject_titles, :document_id
    remove_column :lobject_topics, :document_id
    remove_column :lobject_urls, :document_id

    drop_table :lobject_documents
    drop_table :document_age_ranges
    drop_table :document_alignments
    drop_table :document_downloads
    drop_table :document_grades
    drop_table :document_identities
    drop_table :document_languages
    drop_table :document_resource_types
    drop_table :document_subjects
    drop_table :document_topics
    drop_table :documents
    drop_table :engageny_documents
    drop_table :lr_documents
    drop_table :source_documents
  end
end
