# frozen_string_literal: true

class AddAltNamesToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :alt_names, :text, array: true, default: [], null: false
  end
end
