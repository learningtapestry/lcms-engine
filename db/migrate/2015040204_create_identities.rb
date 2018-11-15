# frozen_string_literal: true

class CreateIdentities < Lcms::Engine::Migration
  def change
    create_table :identities do |t|
      t.string  :url
      t.string  :description
      t.string  :public_key

      t.timestamps
    end

    add_index :identities, :url
  end
end
