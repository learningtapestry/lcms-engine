# frozen_string_literal: true

class CreateOrganizations < Lcms::Engine::Migration
  def change
    create_table :organizations do |t|
      t.string :name
    end
  end
end
