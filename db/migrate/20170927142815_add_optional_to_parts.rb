# frozen_string_literal: true

class AddOptionalToParts < Lcms::Engine::Migration
  def change
    add_column :document_parts, :optional, :boolean, default: false, null: false
  end
end
