# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :settings do |t|
      t.boolean :editing_enabled, default: true, null: false

      t.timestamps null: false
    end
  end
end
