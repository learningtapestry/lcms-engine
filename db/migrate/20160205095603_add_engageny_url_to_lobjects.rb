# frozen_string_literal: true

class AddEngagenyUrlToLobjects < ActiveRecord::Migration[4.2]
  def change
    add_column :lobjects, :engageny_url, :string
  end
end
