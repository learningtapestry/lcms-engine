# frozen_string_literal: true

class AddBreadcrumbTitleToCurriculums < Lcms::Engine::Migration
  def change
    add_column :curriculums, :breadcrumb_title, :string
  end
end
