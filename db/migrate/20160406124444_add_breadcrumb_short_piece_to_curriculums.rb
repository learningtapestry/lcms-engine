# frozen_string_literal: true

class AddBreadcrumbShortPieceToCurriculums < ActiveRecord::Migration[4.2]
  def change
    add_column :curriculums, :breadcrumb_short_piece, :string
  end
end
