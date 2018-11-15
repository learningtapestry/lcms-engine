# frozen_string_literal: true

class AddStandardStrandIdToStandards < Lcms::Engine::Migration
  def change
    add_reference :standards, :standard_strand, index: true, foreign_key: true
  end
end
