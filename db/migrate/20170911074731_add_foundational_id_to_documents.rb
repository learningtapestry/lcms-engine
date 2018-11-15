# frozen_string_literal: true

class AddFoundationalIdToDocuments < Lcms::Engine::Migration
  def change
    add_column :documents, :foundational_file_id, :string
  end
end
