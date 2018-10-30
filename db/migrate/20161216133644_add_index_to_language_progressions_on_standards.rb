# frozen_string_literal: true

class AddIndexToLanguageProgressionsOnStandards < ActiveRecord::Migration[4.2]
  def change
    add_index :standards, :is_language_progression_standard
  end
end
