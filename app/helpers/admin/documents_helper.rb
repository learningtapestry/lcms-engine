# frozen_string_literal: true

module Admin
  module DocumentsHelper
    def material_urls(material, doc)
      lesson = Lcms::Engine::DocumentGenerator.document_presenter.new(doc)
      presenter = Lcms::Engine::DocumentGenerator.material_presenter.new(material, lesson:)
      { pdf: presenter.pdf_url, gdoc: presenter.gdoc_url }
    end
  end
end
