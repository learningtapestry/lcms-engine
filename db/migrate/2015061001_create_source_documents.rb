# frozen_string_literal: true

class CreateSourceDocuments < ActiveRecord::Migration[4.2]
  def up
    create_table :source_documents do |t|
      t.integer :source_id, index: true
      t.string  :source_type, index: true

      t.datetime :conformed_at, index: true
      t.timestamps null: false
    end

    remove_column :engageny_documents, :conformed_at
    remove_column :lr_documents, :conformed_at
  end

  def down
    add_column :engageny_documents, :conformed_at, :datetime, index: true
    add_column :lr_documents, :conformed_at, :datetime, index: true

    drop_table :source_documents
  end
end
