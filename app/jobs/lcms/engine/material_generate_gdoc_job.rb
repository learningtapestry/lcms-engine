# frozen_string_literal: true

module Lcms
  module Engine
    class MaterialGenerateGdocJob < Lcms::Engine::ApplicationJob
      include ResqueJob
      include RetryDelayed

      queue_as :default

      def perform(material, document)
        return if material.pdf?

        material = DocumentGenerator.material_presenter.new(
          material,
          document: DocumentGenerator.document_presenter.new(document)
        )

        # Check if material is optional for current document
        options = {}.tap do |x|
          x[:prefix] = 'optional-' if material.optional_for?(document)
        end

        gdoc = DocumentExporter::Gdoc::Material.new(material, options).export

        new_links = {
          'materials' => {
            material.id.to_s => { 'gdoc' => gdoc.url }
          }
        }

        document.with_lock do
          links = document.reload.links
          document.update links: links.deep_merge(new_links)
        end

        Lcms::Engine::DocumentGenerateJob.perform_later(document, check_queue: true)
      end
    end
  end
end
