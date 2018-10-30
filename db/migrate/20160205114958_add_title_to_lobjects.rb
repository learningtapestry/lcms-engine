# frozen_string_literal: true

class AddTitleToLobjects < ActiveRecord::Migration[4.2]
  def change
    add_column :lobjects, :title, :string
  end
end
