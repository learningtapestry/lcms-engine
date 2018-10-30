# frozen_string_literal: true

class AddShortTitleToLobjects < ActiveRecord::Migration[4.2]
  def change
    add_column :lobjects, :short_title, :string
  end
end
