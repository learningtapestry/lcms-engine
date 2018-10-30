# frozen_string_literal: true

class AddOptionalToParts < ActiveRecord::Migration[4.2]
  def change
    add_column :document_parts, :optional, :boolean, default: false, null: false
  end
end
