# frozen_string_literal: true

class AddCurriculumToResources < ActiveRecord::Migration[4.2]
  def change
    add_reference :resources, :curriculum, index: true
  end
end
