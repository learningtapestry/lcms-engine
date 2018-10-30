# frozen_string_literal: true

class AddMoreColumnsToContentGuideStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :content_guide_standards, :alt_statement_notation, :string
    add_column :content_guide_standards, :asn_identifier, :string, null: false, default: ''
    add_column :content_guide_standards, :grade, :string, null: false, default: ''
    add_column :content_guide_standards, :standard_id, :string, null: false, default: ''
    add_column :content_guide_standards, :subject, :string, null: false, default: ''

    rename_column :content_guide_standards, :name, :statement_notation
    change_column :content_guide_standards, :statement_notation, :string, null: true

    add_index :content_guide_standards, :alt_statement_notation
    add_index :content_guide_standards, :standard_id

    remove_index :content_guide_standards, column: :statement_notation
    add_index :content_guide_standards, :statement_notation
  end
end
