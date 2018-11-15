# frozen_string_literal: true

class AddTypeToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :type, :string
    add_index :standards, :type
  end
end
