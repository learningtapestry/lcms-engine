# frozen_string_literal: true

class AddFsNameToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :fs_name, :string
  end
end
