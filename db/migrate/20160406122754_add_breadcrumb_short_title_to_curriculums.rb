# frozen_string_literal: true

class AddBreadcrumbShortTitleToCurriculums < Lcms::Engine::Migration
  def change
    add_column :curriculums, :breadcrumb_short_title, :string
  end
end
