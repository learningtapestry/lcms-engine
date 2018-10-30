# frozen_string_literal: true

class CreateMaterials < ActiveRecord::Migration[4.2]
  def change
    create_table :materials do |t|
      t.text :content
      t.string :file_id, index: true, null: false
      t.string :identifier, index: true
      t.jsonb :metadata, default: {}, null: false
      t.string :name
      t.datetime :last_modified_at
      t.string :last_author_email
      t.string :last_author_name
      t.text :original_content
      t.string :version

      t.timestamps null: false
    end

    add_index :materials, :metadata, using: :gin, order: 'jsonb_path_ops'
  end
end
