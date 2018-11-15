# frozen_string_literal: true

class AddOprDescriptionToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :opr_description, :string
  end
end
