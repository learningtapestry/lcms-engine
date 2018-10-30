# frozen_string_literal: true

class CreateLobjectTitles < ActiveRecord::Migration[4.2]
  def change
    create_table :lobject_titles do |t|
      t.string :title
      t.belongs_to :lobject
      t.timestamps
    end
  end
end
