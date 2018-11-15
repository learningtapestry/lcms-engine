# frozen_string_literal: true

class CreateDownloadCategories < Lcms::Engine::Migration
  def change
    create_table :download_categories do |t|
      t.string :name, null: false
      t.string :description
    end
  end
end
