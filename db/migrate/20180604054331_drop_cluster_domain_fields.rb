# frozen_string_literal: true

class DropClusterDomainFields < ActiveRecord::Migration[4.2]
  def up
    remove_columns :standards, :cluster_id, :domain_id
  end

  def down
    add_column :standards, :cluster_id, :integer
    add_foreign_key :standards, :standards, column: :cluster_id
    add_index :standards, :cluster_id

    add_column :standards, :domain_id, :integer
    add_foreign_key :standards, :standards, column: :domain_id
    add_index :standards, :domain_id
  end
end
