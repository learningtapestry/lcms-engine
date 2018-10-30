# frozen_string_literal: true

class CreateContentGuideStandards < ActiveRecord::Migration[4.2]
  def change
    create_table :content_guide_standards do |t|
      t.references :content_guide, null: false
      t.references :standard, index: true, null: false

      t.timestamps null: false

      t.index %i(content_guide_id standard_id), name: 'index_content_guide_standards', unique: true

      t.foreign_key :content_guides, on_delete: :cascade
      t.foreign_key :standards, on_deleted: :cascade
    end
  end
end
