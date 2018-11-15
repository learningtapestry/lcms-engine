# frozen_string_literal: true

class CreateUserCategories < Lcms::Engine::Migration
  def change
    create_table :user_categories do |t|
      t.references :user, index: true, foreign_key: true
      t.string :content_type, index: true
      t.string :user_type, index: true
      t.timestamps null: false
    end
  end
end
