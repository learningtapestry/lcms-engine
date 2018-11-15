# frozen_string_literal: true

class DropStandardDomains < Lcms::Engine::Migration
  def change
    remove_column :standards, :standard_domain_id
    drop_table :standard_domains
  end
end
