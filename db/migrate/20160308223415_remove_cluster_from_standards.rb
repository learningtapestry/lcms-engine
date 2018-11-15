# frozen_string_literal: true

class RemoveClusterFromStandards < Lcms::Engine::Migration
  def change
    remove_column :standards, :cluster
  end
end
