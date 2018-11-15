# frozen_string_literal: true

class RemoveCurriculums < Lcms::Engine::Migration
  def change
    # Resource has a tree field now
    remove_column :resources, :curriculum_tree_id
    drop_table :curriculum_trees

    # slugs are stored on the resource itself
    drop_table :resource_slugs

    # resource itself holds the tree info, no need for an curriculum model
    remove_column :curriculums, :curriculum_type_id
    drop_table :curriculum_types
    drop_table :curriculums
  end
end
