# frozen_string_literal: true

class AddShortTitleToLobjectTitles < Lcms::Engine::Migration
  def change
    add_column :lobject_titles, :short_title, :string
  end
end
