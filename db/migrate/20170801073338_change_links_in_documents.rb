# frozen_string_literal: true

class ChangeLinksInDocuments < ActiveRecord::Migration[4.2]
  def change
    change_column_default :documents, :links, nil
    change_column :documents, :links, 'jsonb USING CAST(links AS jsonb)', default: {}, null: false
  end
end
