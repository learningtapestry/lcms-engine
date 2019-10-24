# frozen_string_literal: true

module Admin
  module DocumentsHelper
    def material_urls(material, doc)
      lesson = Lcms::Engine::DocumentPresenter.new(doc)
      presenter = Lcms::Engine::MaterialPresenter.new(material, lesson: lesson)
      { pdf: presenter.pdf_url, gdoc: presenter.gdoc_url }
    end
  end
end
