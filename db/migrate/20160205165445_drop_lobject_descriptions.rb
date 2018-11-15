# frozen_string_literal: true

class DropLobjectDescriptions < Lcms::Engine::Migration
  def change
    drop_table :lobject_descriptions
  end
end
