# frozen_string_literal: true

class ChangeCopyrightAttributionsToResources < Lcms::Engine::Migration
  def change
    add_reference :copyright_attributions, :resource, foreign_key: true
  end

  def data
    CopyrightAttribution.all.each do |copyright_attribution|
      resource = Curriculum.find(copyright_attribution.curriculum_id).resource
      copyright_attribution.resource = resource
      copyright_attribution.save!
    end
  end
end
