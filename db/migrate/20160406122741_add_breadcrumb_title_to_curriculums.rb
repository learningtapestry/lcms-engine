# frozen_string_literal: true

class AddBreadcrumbTitleToCurriculums < ActiveRecord::Migration[4.2]
  def change
    add_column :curriculums, :breadcrumb_title, :string
  end
end
