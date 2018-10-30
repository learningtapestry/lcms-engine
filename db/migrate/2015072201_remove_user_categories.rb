# frozen_string_literal: true

class RemoveUserCategories < ActiveRecord::Migration[4.2]
  def change
    remove_column :document_subjects, :user_category_id
    remove_column :lobject_subjects, :user_category_id
    drop_table :user_categories
  end
end
