# frozen_string_literal: true

class RemoveDomainFromStandards < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :domain
  end
end
