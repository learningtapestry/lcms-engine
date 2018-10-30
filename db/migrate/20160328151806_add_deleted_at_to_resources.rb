# frozen_string_literal: true

class AddDeletedAtToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :deleted_at, :datetime
    add_index :resources, :deleted_at
  end
end
