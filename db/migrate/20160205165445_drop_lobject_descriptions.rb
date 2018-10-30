# frozen_string_literal: true

class DropLobjectDescriptions < ActiveRecord::Migration[4.2]
  def change
    drop_table :lobject_descriptions
  end
end
