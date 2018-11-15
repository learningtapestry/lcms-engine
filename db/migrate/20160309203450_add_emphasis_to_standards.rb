# frozen_string_literal: true

class AddEmphasisToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :emphasis, :string
    add_index :standards, :emphasis
  end
end
