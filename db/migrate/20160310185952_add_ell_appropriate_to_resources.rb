# frozen_string_literal: true

class AddEllAppropriateToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :ell_appropriate, :boolean, null: false, default: false
  end
end
