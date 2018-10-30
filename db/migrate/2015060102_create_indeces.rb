# frozen_string_literal: true

class CreateIndeces < ActiveRecord::Migration[4.2]
  def change # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    add_index :alignments, :parent_id
    add_foreign_key :alignments, :alignments, column: :parent_id

    add_index :document_age_ranges, :document_id
    add_foreign_key :document_age_ranges, :documents

    add_index :document_alignments, :document_id
    add_index :document_alignments, :alignment_id
    add_foreign_key :document_alignments, :alignments
    add_foreign_key :document_alignments, :documents

    add_index :document_identities, :document_id
    add_index :document_identities, :identity_id
    add_index :document_identities, :identity_type
    add_foreign_key :document_identities, :identities
    add_foreign_key :document_identities, :documents

    add_index :document_keywords, :document_id
    add_index :document_keywords, :keyword_id
    add_foreign_key :document_keywords, :keywords
    add_foreign_key :document_keywords, :documents

    add_index :document_languages, :document_id
    add_index :document_languages, :language_id
    add_foreign_key :document_languages, :languages
    add_foreign_key :document_languages, :documents

    add_index :document_resource_types, :document_id
    add_index :document_resource_types, :resource_type_id
    add_foreign_key :document_resource_types, :resource_types
    add_foreign_key :document_resource_types, :documents

    add_index :documents, :lr_document_id
    add_index :documents, :url_id
    add_index :documents, :merged_at
    add_foreign_key :documents, :lr_documents
    add_foreign_key :documents, :urls

    add_index :identities, :parent_id
    add_foreign_key :identities, :identities, column: :parent_id

    add_foreign_key :keywords, :keywords, column: :parent_id

    add_foreign_key :languages, :languages, column: :parent_id

    add_index :lobject_age_ranges, :lobject_id
    add_index :lobject_age_ranges, :document_id
    add_foreign_key :lobject_age_ranges, :lobjects
    add_foreign_key :lobject_age_ranges, :documents

    add_index :lobject_alignments, :lobject_id
    add_index :lobject_alignments, :alignment_id
    add_index :lobject_alignments, :document_id
    add_foreign_key :lobject_alignments, :alignments
    add_foreign_key :lobject_alignments, :lobjects
    add_foreign_key :lobject_alignments, :documents

    add_index :lobject_descriptions, :lobject_id
    add_index :lobject_descriptions, :document_id
    add_foreign_key :lobject_descriptions, :lobjects
    add_foreign_key :lobject_descriptions, :documents

    add_index :lobject_documents, :lobject_id
    add_index :lobject_documents, :document_id
    add_foreign_key :lobject_documents, :lobjects
    add_foreign_key :lobject_documents, :documents

    add_index :lobject_identities, :lobject_id
    add_index :lobject_identities, :identity_id
    add_index :lobject_identities, :identity_type
    add_index :lobject_identities, :document_id
    add_foreign_key :lobject_identities, :identities
    add_foreign_key :lobject_identities, :lobjects
    add_foreign_key :lobject_identities, :documents

    add_index :lobject_keywords, :lobject_id
    add_index :lobject_keywords, :keyword_id
    add_index :lobject_keywords, :document_id
    add_foreign_key :lobject_keywords, :keywords
    add_foreign_key :lobject_keywords, :lobjects
    add_foreign_key :lobject_keywords, :documents

    add_index :lobject_languages, :lobject_id
    add_index :lobject_languages, :language_id
    add_index :lobject_languages, :document_id
    add_foreign_key :lobject_languages, :languages
    add_foreign_key :lobject_languages, :lobjects
    add_foreign_key :lobject_languages, :documents

    add_index :lobject_resource_types, :lobject_id
    add_index :lobject_resource_types, :resource_type_id
    add_index :lobject_resource_types, :document_id
    add_foreign_key :lobject_resource_types, :resource_types
    add_foreign_key :lobject_resource_types, :lobjects
    add_foreign_key :lobject_resource_types, :documents

    add_index :lobject_titles, :lobject_id
    add_index :lobject_titles, :document_id
    add_foreign_key :lobject_titles, :lobjects
    add_foreign_key :lobject_titles, :documents

    add_index :lobject_urls, :lobject_id
    add_index :lobject_urls, :url_id
    add_index :lobject_urls, :document_id
    add_foreign_key :lobject_urls, :urls
    add_foreign_key :lobject_urls, :lobjects
    add_foreign_key :lobject_urls, :documents

    add_index :lobjects, :indexed_at

    add_foreign_key :resource_types, :resource_types, column: :parent_id

    add_index :urls, :url
    add_index :urls, :checked_at
    add_foreign_key :urls, :urls, column: :parent_id
  end
end
