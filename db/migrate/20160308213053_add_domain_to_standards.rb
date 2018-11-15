# frozen_string_literal: true

class AddDomainToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :domain, :string, index: true
    add_index :standards, :domain
  end
end
