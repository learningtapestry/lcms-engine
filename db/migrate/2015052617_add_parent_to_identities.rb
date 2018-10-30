# frozen_string_literal: true

class AddParentToIdentities < ActiveRecord::Migration[4.2]
  def change
    change_table :identities do |t|
      t.references :parent, references: :identities
    end
  end
end
