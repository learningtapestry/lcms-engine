# frozen_string_literal: true

class AddNameToIdentities < Lcms::Engine::Migration
  def change
    change_table :identities do |t|
      t.string :name
    end
  end
end
