# frozen_string_literal: true

class AddMetadataColumnsToContentGuides < ActiveRecord::Migration[4.2]
  def change
    add_column :content_guides, :big_photo, :string
    add_column :content_guides, :date, :date
    add_column :content_guides, :description, :string
    add_column :content_guides, :grade, :string
    add_column :content_guides, :small_photo, :string
    add_column :content_guides, :subject, :string
    add_column :content_guides, :teaser, :string
    add_column :content_guides, :title, :string
  end
end
