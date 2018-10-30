# frozen_string_literal: true

class RenameLobjectTables < ActiveRecord::Migration[4.2]
  def change
    rename_column :lobject_additional_lobjects, :lobject_id, :resource_id
    rename_column :lobject_additional_lobjects, :additional_lobject_id, :additional_resource_id
    rename_index :lobject_additional_lobjects, 'index_lobject_additional_lobjects',
                 'index_resource_additional_resources'
    rename_table :lobject_additional_lobjects, :resource_additional_resources

    rename_column :lobject_alignments, :lobject_id, :resource_id
    rename_table :lobject_alignments, :resource_alignments

    rename_column :lobject_children, :lobject_collection_id, :resource_collection_id
    rename_table :lobject_children, :resource_children

    rename_column :lobject_collections, :lobject_collection_type_id, :resource_collection_type_id
    rename_column :lobject_collections, :lobject_id, :resource_id
    rename_table :lobject_collections, :resource_collections

    rename_table :lobject_collection_types, :resource_collection_types

    rename_column :lobject_downloads, :lobject_id, :resource_id
    rename_table :lobject_downloads, :resource_downloads

    rename_column :lobject_grades, :lobject_id, :resource_id
    rename_table :lobject_grades, :resource_grades

    rename_column :lobject_related_lobjects, :lobject_id, :resource_id
    rename_column :lobject_related_lobjects, :related_lobject_id, :related_resource_id
    rename_table :lobject_related_lobjects, :resource_related_resources

    rename_column :lobject_resource_types, :lobject_id, :resource_id
    rename_table :lobject_resource_types, :resource_resource_types

    rename_column :lobject_slugs, :lobject_collection_id, :resource_collection_id
    rename_column :lobject_slugs, :lobject_id, :resource_id
    rename_table :lobject_slugs, :resource_slugs

    rename_column :lobject_subjects, :lobject_id, :resource_id
    rename_table :lobject_subjects, :resource_subjects

    rename_column :lobject_topics, :lobject_id, :resource_id
    rename_table :lobject_topics, :resource_topics

    rename_table :lobjects, :resources
  end
end
