# frozen_string_literal: true

class CreateEngagenyDocuments < Lcms::Engine::Migration
  def change
    create_table :engageny_documents do |t|
      t.integer :nid, index: true
      t.text :title
      t.text :description
      t.datetime :doc_created_at
      t.jsonb :grades
      t.jsonb :subjects
      t.jsonb :topics
      t.jsonb :resource_types
      t.jsonb :standards
      t.jsonb :downloadable_resources
      t.string :url
      t.datetime :conformed_at, index: true
    end

    add_index :engageny_documents, :grades, using: :gin
    add_index :engageny_documents, :subjects, using: :gin
    add_index :engageny_documents, :topics, using: :gin
    add_index :engageny_documents, :resource_types, using: :gin
    add_index :engageny_documents, :standards, using: :gin
    add_index :engageny_documents, :downloadable_resources, using: :gin
  end
end
