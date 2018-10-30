# frozen_string_literal: true

class AddEngagenyTitleToLobjects < ActiveRecord::Migration[4.2]
  def change
    add_column :lobjects, :engageny_title, :string
  end
end
