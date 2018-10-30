# frozen_string_literal: true

class RemoveFrameworkAndFrameworkUrlFromStandards < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :framework
    remove_column :standards, :framework_url
  end
end
