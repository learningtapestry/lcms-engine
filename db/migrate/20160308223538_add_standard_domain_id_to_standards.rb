# frozen_string_literal: true

class AddStandardDomainIdToStandards < ActiveRecord::Migration[4.2]
  def change
    add_reference :standards, :standard_domain, index: true, foreign_key: true
  end
end
