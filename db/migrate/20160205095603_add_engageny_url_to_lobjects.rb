# frozen_string_literal: true

class AddEngagenyUrlToLobjects < Lcms::Engine::Migration
  def change
    add_column :lobjects, :engageny_url, :string
  end
end
