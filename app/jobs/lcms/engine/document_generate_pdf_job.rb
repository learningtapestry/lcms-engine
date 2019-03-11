# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentGeneratePdfJob < Lcms::Engine::ApplicationJob
      include ResqueJob
      include RetrySimple

      queue_as :default

      PDF_EXPORTERS = {
        'full' => DocumentExporter::PDF::Document,
        'sm' => DocumentExporter::PDF::StudentMaterial,
        'tm' => DocumentExporter::PDF::TeacherMaterial
      }.freeze

      def perform(doc, options)
        content_type = options[:content_type]
        document = DocumentPresenter.new doc.reload, content_type: content_type
        filename = options[:filename].presence || "#{DocumentExporter::PDF::Base.s3_folder}/#{document.pdf_filename}"
        pdf = PDF_EXPORTERS[content_type].new(document, options).export
        url = S3Service.upload filename, pdf

        return if options[:excludes].present?

        key = ::DocumentExporter::PDF::Base.pdf_key options[:content_type]
        document.with_lock do
          document.update links: document.reload.links.merge(key => url)
        end
      end
    end
  end
end
