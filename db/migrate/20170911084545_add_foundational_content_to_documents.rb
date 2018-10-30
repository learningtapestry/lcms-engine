# frozen_string_literal: true

class AddFoundationalContentToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :foundational_content, :text
  end
end
