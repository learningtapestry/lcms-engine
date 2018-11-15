# frozen_string_literal: true

class RemoveFrameworkAndFrameworkUrlFromStandards < Lcms::Engine::Migration
  def change
    remove_column :standards, :framework
    remove_column :standards, :framework_url
  end
end
