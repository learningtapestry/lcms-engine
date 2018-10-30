# frozen_string_literal: true

class DropLobjectTitleDescription < ActiveRecord::Migration[4.2]
  def change
    change_table :lobjects do |t|
      t.remove :title
      t.remove :description
    end
  end
end
