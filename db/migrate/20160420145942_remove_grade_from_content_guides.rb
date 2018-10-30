# frozen_string_literal: true

class RemoveGradeFromContentGuides < ActiveRecord::Migration[4.2]
  def change
    remove_column :content_guides, :grade, :string
  end
end
