# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentGeneratePdfJob < Lcms::Engine::ApplicationJob
      include ResqueJob
      include RetrySimple

      queue_as :default

      PDF_EXPORTERS = {
        'full' => ::DocumentExporter::Pdf::Document,
        'sm' => ::DocumentExporter::Pdf::StudentMaterial,
        'tm' => ::DocumentExporter::Pdf::TeacherMaterial
      }.freeze

      def perform(doc, options)
        content_type = options[:content_type]
        document = DocumentGenerator.document_presenter.new(doc.reload, content_type:)
        filename = options[:filename].presence || "#{::DocumentExporter::Pdf::Base.s3_folder}/#{document.pdf_filename}"
        pdf = PDF_EXPORTERS[content_type].new(document, options).export
        url = S3Service.upload filename, pdf

        return if options[:excludes].present?

        key = ::DocumentExporter::Pdf::Base.pdf_key options[:content_type]
        document.with_lock do
          document.update links: document.reload.links.merge(key => url)
        end
      end
    end
  end
end
