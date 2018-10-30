# frozen_string_literal: true

class AddTimeToTeachToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :time_to_teach, :integer
  end
end
