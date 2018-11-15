# frozen_string_literal: true

class AddSubjectToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :subject, :string
  end
end
