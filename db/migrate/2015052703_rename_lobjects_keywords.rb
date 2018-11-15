# frozen_string_literal: true

class RenameLobjectsKeywords < Lcms::Engine::Migration
  def change
    rename_table :lobjects_keywords, :lobject_keywords
  end
end
