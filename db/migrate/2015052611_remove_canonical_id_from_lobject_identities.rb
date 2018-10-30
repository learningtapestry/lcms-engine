# frozen_string_literal: true

class RemoveCanonicalIdFromLobjectIdentities < ActiveRecord::Migration[4.2]
  def change
    change_table :lobject_identities do |t|
      t.remove :canonical_id
    end
  end
end
