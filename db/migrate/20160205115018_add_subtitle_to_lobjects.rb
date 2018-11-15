# frozen_string_literal: true

class AddSubtitleToLobjects < Lcms::Engine::Migration
  def change
    add_column :lobjects, :subtitle, :string
  end
end
