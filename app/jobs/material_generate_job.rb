# frozen_string_literal: true

class MaterialGenerateJob < Lcms::Engine::ApplicationJob
  include ResqueJob

  queue_as :default

  def perform(material, document)
    material.material_parts.default.each { |p| p.update!(content: EmbedEquations.call(p.content)) } if document.math?

    DocumentGenerator.material_generators.each do |klass|
      klass.constantize.perform_later material, document
    end
  end
end
