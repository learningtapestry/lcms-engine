# frozen_string_literal: true

class CreateCurriculumTypes < Lcms::Engine::Migration
  def change
    create_table :curriculum_types do |t|
      t.string :name, null: false
    end
  end
end
