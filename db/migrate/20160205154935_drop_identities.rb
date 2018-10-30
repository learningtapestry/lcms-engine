# frozen_string_literal: true

class DropIdentities < ActiveRecord::Migration[4.2]
  def change
    drop_table :lobject_identities
    drop_table :identities
  end
end
