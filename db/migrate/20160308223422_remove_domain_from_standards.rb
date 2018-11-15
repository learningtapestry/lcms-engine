# frozen_string_literal: true

class RemoveDomainFromStandards < Lcms::Engine::Migration
  def change
    remove_column :standards, :domain
  end
end
