# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Document < PDF::Base
      def export
        content = super
        pdf = CombinePDF.parse(content)

        material_ids = @document.ordered_material_ids
        material_ids &= @document.gdoc_material_ids
        material_ids &= included_materials

        pdf = combine_pdf_for pdf, material_ids
        pdf.to_pdf
      end
    end
  end
end
