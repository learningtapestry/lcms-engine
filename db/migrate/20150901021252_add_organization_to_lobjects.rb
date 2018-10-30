# frozen_string_literal: true

class AddOrganizationToLobjects < ActiveRecord::Migration[4.2]
  def change
    add_reference :lobjects, :organization, index: true, foreign_key: true
  end
end
