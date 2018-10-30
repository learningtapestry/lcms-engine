# frozen_string_literal: true

class AddBreadcrumbPieceToCurriculums < ActiveRecord::Migration[4.2]
  def change
    add_column :curriculums, :breadcrumb_piece, :string
  end
end
