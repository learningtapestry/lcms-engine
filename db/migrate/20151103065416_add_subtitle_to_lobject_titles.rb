# frozen_string_literal: true

class AddSubtitleToLobjectTitles < Lcms::Engine::Migration
  def change
    add_column :lobject_titles, :subtitle, :string
  end
end
