# frozen_string_literal: true

class CreateAlignments < Lcms::Engine::Migration
  def change
    create_table :alignments do |t|
      t.string  :name
      t.string  :framework
      t.string  :framework_url

      t.timestamps
    end

    add_index :alignments, :framework
    add_index :alignments, :framework_url
  end
end
