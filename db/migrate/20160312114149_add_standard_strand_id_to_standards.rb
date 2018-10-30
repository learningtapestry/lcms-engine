# frozen_string_literal: true

class AddStandardStrandIdToStandards < ActiveRecord::Migration[4.2]
  def change
    add_reference :standards, :standard_strand, index: true, foreign_key: true
  end
end
