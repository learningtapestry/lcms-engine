# frozen_string_literal: true

class ChangeLobjects < ActiveRecord::Migration[4.2]
  def change
    change_table :lobjects do |t|
      t.boolean :hidden, index: true, default: false
    end
  end
end
