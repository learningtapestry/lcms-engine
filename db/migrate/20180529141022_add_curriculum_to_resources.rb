# frozen_string_literal: true

class AddCurriculumToResources < Lcms::Engine::Migration
  def change
    add_reference :resources, :curriculum, index: true
  end
end
