# frozen_string_literal: true

class CreateAccessCodes < Lcms::Engine::Migration
  def change
    create_table :access_codes do |t|
      t.string :code, null: false
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end

    add_index :access_codes, :code, unique: true
  end
end
