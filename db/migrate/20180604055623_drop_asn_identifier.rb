# frozen_string_literal: true

class DropAsnIdentifier < Lcms::Engine::Migration
  def up
    remove_column :standards, :asn_identifier
  end

  def down
    add_column :standards, :asn_identifier, :string
    add_index :standards, :asn_identifier, unique: true
  end
end
