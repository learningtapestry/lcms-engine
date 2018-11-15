# frozen_string_literal: true

class RemoveEmphasisFromStandards < Lcms::Engine::Migration
  def change
    remove_column :standards, :emphasis
  end
end
