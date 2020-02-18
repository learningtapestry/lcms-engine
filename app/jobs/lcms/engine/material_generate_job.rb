# frozen_string_literal: true

module Lcms
  module Engine
    class MaterialGenerateJob < Lcms::Engine::ApplicationJob
      include ResqueJob

      queue_as :default

      def perform(material, document)
        if document.math?
          material.document_parts.default.each { |p| p.update!(content: EmbedEquations.call(p.content)) }
        end

        DocumentGenerator.material_generators.each do |klass|
          klass.constantize.perform_later material, document
        end
      end
    end
  end
end
