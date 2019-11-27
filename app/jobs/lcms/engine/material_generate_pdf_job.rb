# frozen_string_literal: true

module Lcms
  module Engine
    class MaterialGeneratePDFJob < Lcms::Engine::ApplicationJob
      include ResqueJob

      include RetrySimple

      queue_as :default

      def perform(material, document)
        material_links = material.pdf? ? links_from_metadata(material) : links_from_upload(material, document)

        new_links = {
          'materials' => {
            material.id.to_s => material_links
          }
        }

        document.with_lock do
          links = document.reload.links
          document.update links: links.deep_merge(new_links)
        end

        Lcms::Engine::DocumentGenerateJob.perform_later(document, check_queue: true)
      end

      private

      def links_from_upload(material, document)
        material = material_presenter(material, document)

        basename = "#{DocumentExporter::PDF::Base.s3_folder}/#{material.pdf_filename}"
        pdf_filename = "#{basename}#{ContentPresenter::PDF_EXT}"
        thumb_filename = "#{basename}#{ContentPresenter::THUMB_EXT}"

        pdf = DocumentExporter::PDF::Material.new(material).export
        thumb = DocumentExporter::Thumbnail.new(pdf).export

        pdf_url = S3Service.upload pdf_filename, pdf
        thumb_url = S3Service.upload thumb_filename, thumb

        { 'url' => pdf_url, 'thumb' => thumb_url }
      end

      def material_presenter(material, document)
        DocumentGenerator.material_presenter.new material, lesson: DocumentGenerator.document_presenter.new(document)
      end

      def links_from_metadata(material)
        { 'url' => material.metadata['pdf_url'], 'thumb' => material.metadata['thumb_url'] }
      end
    end
  end
end
