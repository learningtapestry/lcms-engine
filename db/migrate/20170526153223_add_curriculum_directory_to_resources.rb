# frozen_string_literal: true

class AddCurriculumDirectoryToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :curriculum_type, :string, index: true
    add_column :resources, :curriculum_directory, :text, array: true, default: [], null: false, index: true

    add_reference :resources, :curriculum_tree, index: true
  end
end
