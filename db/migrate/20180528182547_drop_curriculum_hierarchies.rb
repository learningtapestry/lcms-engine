# frozen_string_literal: true

class DropCurriculumHierarchies < Lcms::Engine::Migration
  def change
    drop_table :curriculum_hierarchies do |t|
      t.integer 'ancestor_id', null: false
      t.integer 'descendant_id', null: false
      t.integer 'generations', null: false
    end
  end
end
