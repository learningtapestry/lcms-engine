# frozen_string_literal: true

class AddDomainIdToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :domain_id, :integer
    add_foreign_key :standards, :standards, column: :domain_id
    add_index :standards, :domain_id
  end
end
