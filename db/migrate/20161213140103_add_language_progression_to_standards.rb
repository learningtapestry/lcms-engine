# frozen_string_literal: true

class AddLanguageProgressionToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :language_progression_file, :string
    add_column :standards, :language_progression_note, :string
    add_column :standards, :is_language_progression_standard, :boolean, null: false, default: false
  end
end
