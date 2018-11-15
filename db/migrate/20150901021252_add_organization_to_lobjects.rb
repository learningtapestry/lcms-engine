# frozen_string_literal: true

class AddOrganizationToLobjects < Lcms::Engine::Migration
  def change
    add_reference :lobjects, :organization, index: true, foreign_key: true
  end
end
