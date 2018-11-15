# frozen_string_literal: true

class AddTimeToTeachToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :time_to_teach, :integer
  end
end
