# frozen_string_literal: true

class DocumentGenerator
  CONTENT_TYPES = %w(full tm sm).freeze

  DOCUMENT_GENERATORS = {
    gdoc: 'DocumentGenerateGdocJob',
    pdf: 'DocumentGeneratePdfJob'
  }.with_indifferent_access.freeze

  MATERIAL_GENERATORS = {
    gdoc: 'MaterialGenerateGdocJob',
    pdf: 'MaterialGeneratePDFJob'
  }.with_indifferent_access.freeze

  MATERIAL_PRESENTER = 'MaterialPresenter'

  class << self
    def generate_for(document)
      reset_links document
      DocumentGenerateJob.perform_later(document)
    end

    def document_generators
      @document_generators ||= DOCUMENT_GENERATORS.slice(*DocTemplate.document_contexts).values
    end

    def material_generators
      @material_generators ||= MATERIAL_GENERATORS.slice(*DocTemplate.material_contexts).values
    end

    def material_presenter
      @material_presenter ||=
        begin
          klass = DocTemplate.config['material_presenter'].presence || MATERIAL_PRESENTER
          klass.constantize
        end
    end

    private

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
