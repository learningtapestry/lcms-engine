# frozen_string_literal: true

class AddFoundationalIdToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :foundational_file_id, :string
  end
end
