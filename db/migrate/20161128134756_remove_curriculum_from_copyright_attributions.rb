# frozen_string_literal: true

class RemoveCurriculumFromCopyrightAttributions < ActiveRecord::Migration[4.2]
  def change
    remove_reference :copyright_attributions, :curriculum, index: true, foreign_key: true

    change_column_null :copyright_attributions, :resource_id, false
  end
end
