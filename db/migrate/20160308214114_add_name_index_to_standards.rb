# frozen_string_literal: true

class AddNameIndexToStandards < Lcms::Engine::Migration
  def change
    add_index :standards, :name
  end
end
