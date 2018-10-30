# frozen_string_literal: true

class AddBreadcrumbShortTitleToCurriculums < ActiveRecord::Migration[4.2]
  def change
    add_column :curriculums, :breadcrumb_short_title, :string
  end
end
