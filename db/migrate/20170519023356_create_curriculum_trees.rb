# frozen_string_literal: true

class CreateCurriculumTrees < Lcms::Engine::Migration
  def change
    create_table :curriculum_trees do |t|
      t.string  :name,    null: false
      t.jsonb   :tree,    null: false, default: '{}'
      t.boolean :default, null: false, default: false

      t.timestamps null: false
    end
  end
end
