# frozen_string_literal: true

class RemoveCanonicalIdFromLobjectIdentities < Lcms::Engine::Migration
  def change
    change_table :lobject_identities do |t|
      t.remove :canonical_id
    end
  end
end
