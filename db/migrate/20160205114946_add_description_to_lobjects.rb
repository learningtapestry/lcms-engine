# frozen_string_literal: true

class AddDescriptionToLobjects < ActiveRecord::Migration[4.2]
  def change
    add_column :lobjects, :description, :string
  end
end
