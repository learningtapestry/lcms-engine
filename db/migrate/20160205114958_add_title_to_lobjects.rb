# frozen_string_literal: true

class AddTitleToLobjects < Lcms::Engine::Migration
  def change
    add_column :lobjects, :title, :string
  end
end
