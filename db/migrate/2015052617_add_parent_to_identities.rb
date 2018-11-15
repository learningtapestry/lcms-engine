# frozen_string_literal: true

class AddParentToIdentities < Lcms::Engine::Migration
  def change
    change_table :identities do |t|
      t.references :parent, references: :identities
    end
  end
end
