# frozen_string_literal: true

class AddSubtitleToLobjects < ActiveRecord::Migration[4.2]
  def change
    add_column :lobjects, :subtitle, :string
  end
end
