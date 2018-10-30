# frozen_string_literal: true

class AddPdfToContentGuides < ActiveRecord::Migration[4.2]
  def change
    add_column :content_guides, :pdf, :string
  end
end
