# frozen_string_literal: true

class AddEngagenyTitleToLobjects < Lcms::Engine::Migration
  def change
    add_column :lobjects, :engageny_title, :string
  end
end
