# frozen_string_literal: true

class AddSubjectToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :subject, :string
    add_index :standards, :subject
  end
end
