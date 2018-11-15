# frozen_string_literal: true

class AddFoundationalContentToDocuments < Lcms::Engine::Migration
  def change
    add_column :documents, :foundational_content, :text
  end
end
