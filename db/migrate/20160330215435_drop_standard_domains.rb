# frozen_string_literal: true

class DropStandardDomains < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :standard_domain_id
    drop_table :standard_domains
  end
end
