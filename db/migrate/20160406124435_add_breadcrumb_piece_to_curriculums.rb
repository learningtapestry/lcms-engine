# frozen_string_literal: true

class AddBreadcrumbPieceToCurriculums < Lcms::Engine::Migration
  def change
    add_column :curriculums, :breadcrumb_piece, :string
  end
end
