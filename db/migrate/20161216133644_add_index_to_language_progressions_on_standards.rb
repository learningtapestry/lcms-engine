# frozen_string_literal: true

class AddIndexToLanguageProgressionsOnStandards < Lcms::Engine::Migration
  def change
    add_index :standards, :is_language_progression_standard
  end
end
