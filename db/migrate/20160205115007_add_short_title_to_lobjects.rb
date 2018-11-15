# frozen_string_literal: true

class AddShortTitleToLobjects < Lcms::Engine::Migration
  def change
    add_column :lobjects, :short_title, :string
  end
end
