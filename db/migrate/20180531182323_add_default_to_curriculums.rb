# frozen_string_literal: true

class AddDefaultToCurriculums < ActiveRecord::Migration[4.2]
  def change
    add_column :curriculums, :default, :boolean, null: false, default: false
  end
end
