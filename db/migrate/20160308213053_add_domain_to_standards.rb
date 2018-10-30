# frozen_string_literal: true

class AddDomainToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :domain, :string, index: true
    add_index :standards, :domain
  end
end
