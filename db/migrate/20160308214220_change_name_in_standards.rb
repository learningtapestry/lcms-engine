# frozen_string_literal: true

class ChangeNameInStandards < Lcms::Engine::Migration
  def change
    change_column :standards, :name, :string, null: false
  end
end
