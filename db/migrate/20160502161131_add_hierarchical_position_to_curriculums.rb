# frozen_string_literal: true

class AddHierarchicalPositionToCurriculums < ActiveRecord::Migration[4.2]
  def change
    add_column :curriculums, :hierarchical_position, :string, index: true
  end
end
