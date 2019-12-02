# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentGenerator
      CONTENT_TYPES = %w(full tm sm).freeze

      DOCUMENT_GENERATORS = {
        gdoc: '::Lcms::Engine::DocumentGenerateGdocJob',
        pdf: '::Lcms::Engine::DocumentGeneratePdfJob'
      }.with_indifferent_access.freeze

      DOCUMENT_PARSE_JOB = '::Lcms::Engine::DocumentParseJob'
      DOCUMENT_PRESENTER = '::Lcms::Engine::DocumentPresenter'

      MATERIAL_GENERATORS = {
        gdoc: '::Lcms::Engine::MaterialGenerateGdocJob',
        pdf: '::Lcms::Engine::MaterialGeneratePDFJob'
      }.with_indifferent_access.freeze

      MATERIAL_PARSE_JOB = '::Lcms::Engine::MaterialParseJob'
      MATERIAL_PRESENTER = '::Lcms::Engine::MaterialPresenter'

      class << self
        def generate_for(document)
          return material_preview_job&.perform_later(document) if document.is_a?(Lcms::Engine::Material)

          reset_links document
          Lcms::Engine::DocumentGenerateJob.perform_later(document)
        end

        def document_generators
          @document_generators ||= DOCUMENT_GENERATORS.slice(*DocTemplate.document_contexts).values
        end

        def document_parse_job
          @document_parse_job ||=
            begin
              klass = DocTemplate.config['document_parse_job'].presence || DOCUMENT_PARSE_JOB
              klass.constantize
            end
        end

        def document_presenter
          @document_presenter ||=
            begin
              klass = DocTemplate.config['document_presenter'].presence || DOCUMENT_PRESENTER
              klass.constantize
            end
        end

        def material_generators
          @material_generators ||= MATERIAL_GENERATORS.slice(*DocTemplate.material_contexts).values
        end

        def material_form
          @material_form ||= DocTemplate.config['material_form']&.constantize || ::Lcms::Engine::MaterialForm
        end

        def material_parse_job
          @material_parse_job ||=
            begin
              klass = DocTemplate.config['material_parse_job'].presence || MATERIAL_PARSE_JOB
              klass.constantize
            end
        end

        def material_presenter
          @material_presenter ||=
            begin
              klass = DocTemplate.config['material_presenter'].presence || MATERIAL_PRESENTER
              klass.constantize
            end
        end

        private

        def material_preview_job
          @material_preview_job ||= DocTemplate.config['material_preview_job']&.constantize
        end

        # TODO: Refactor to address `DOCUMENT_GENERATORS` way here as well
        def reset_links(document)
          document.links['materials'] = {}
          CONTENT_TYPES.each do |type|
            [
              DocumentExporter::PDF::Base.pdf_key(type),
              DocumentExporter::Gdoc::Base.gdoc_key(type)
            ].each { |key| document.links.delete(key) }
          end
          document.save
        end
      end
    end
  end
end
