# frozen_string_literal: true

class AddSeedIdToCurriculums < Lcms::Engine::Migration
  def change
    add_column :curriculums, :seed_id, :integer, index: true
    add_foreign_key :curriculums, :curriculums, column: :seed_id
  end
end
