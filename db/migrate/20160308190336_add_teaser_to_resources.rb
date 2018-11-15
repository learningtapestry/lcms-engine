# frozen_string_literal: true

class AddTeaserToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :teaser, :string
  end
end
