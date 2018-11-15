# frozen_string_literal: true

class AddDescriptionToLobjects < Lcms::Engine::Migration
  def change
    add_column :lobjects, :description, :string
  end
end
