# frozen_string_literal: true

class DropLobjectTitles < Lcms::Engine::Migration
  def change
    drop_table :lobject_titles
  end
end
