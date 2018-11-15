# frozen_string_literal: true

class DropIdentities < Lcms::Engine::Migration
  def change
    drop_table :lobject_identities
    drop_table :identities
  end
end
