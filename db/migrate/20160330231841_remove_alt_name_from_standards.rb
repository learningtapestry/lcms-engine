# frozen_string_literal: true

class RemoveAltNameFromStandards < Lcms::Engine::Migration
  def change
    remove_column :standards, :alt_name
  end
end
