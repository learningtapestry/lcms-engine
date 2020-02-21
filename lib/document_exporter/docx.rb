# frozen_string_literal: true

require 'pandoc-ruby'

module DocumentExporter
  class Docx
    def initialize(document)
      @document = document
    end

    def export
      PandocRuby.convert content, from: :html, to: :docx
    end

    private

    def content
      @content ||= ApplicationController.render(
        layout: 'ld_docx',
        locals: { :@document => @document },
        template: 'documents/docx/export'
      )
    end
  end
end
