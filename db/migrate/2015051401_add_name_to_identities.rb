# frozen_string_literal: true

class AddNameToIdentities < ActiveRecord::Migration[4.2]
  def change
    change_table :identities do |t|
      t.string :name
    end
  end
end
