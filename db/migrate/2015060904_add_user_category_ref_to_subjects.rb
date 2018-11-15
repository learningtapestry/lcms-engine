# frozen_string_literal: true

class AddUserCategoryRefToSubjects < Lcms::Engine::Migration
  def change
    add_column :document_subjects, :user_category_id, :integer
    add_foreign_key :document_subjects, :user_categories

    add_column :lobject_subjects, :user_category_id, :integer
    add_foreign_key :lobject_subjects, :user_categories
  end
end
