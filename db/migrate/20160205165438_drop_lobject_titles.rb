# frozen_string_literal: true

class DropLobjectTitles < ActiveRecord::Migration[4.2]
  def change
    drop_table :lobject_titles
  end
end
