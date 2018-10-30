# frozen_string_literal: true

class AddSubjectToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :subject, :string
  end
end
