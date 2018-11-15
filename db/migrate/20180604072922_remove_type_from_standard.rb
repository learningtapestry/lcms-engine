# frozen_string_literal: true

class RemoveTypeFromStandard < Lcms::Engine::Migration
  def change
    remove_column :standards, :type, :string
  end
end
