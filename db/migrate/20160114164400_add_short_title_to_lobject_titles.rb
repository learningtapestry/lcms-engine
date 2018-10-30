# frozen_string_literal: true

class AddShortTitleToLobjectTitles < ActiveRecord::Migration[4.2]
  def change
    add_column :lobject_titles, :short_title, :string
  end
end
