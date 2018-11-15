# frozen_string_literal: true

class CreateKeywords < Lcms::Engine::Migration
  def change
    create_table :keywords do |t|
      t.string  :name
      t.string  :source

      t.timestamps
    end

    add_index :keywords, :name
  end
end
