# frozen_string_literal: true

class CreateUsers < Lcms::Engine::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
