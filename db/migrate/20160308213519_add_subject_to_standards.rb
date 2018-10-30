# frozen_string_literal: true

class AddSubjectToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :subject, :string
    add_index :standards, :subject
  end
end
