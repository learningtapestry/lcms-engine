# frozen_string_literal: true

module DocumentExporter
  module PDF
    class TeacherMaterial < PDF::Base
      def export
        content = super
        pdf = CombinePDF.parse(content)

        scope = @document.teacher_materials.where(id: included_materials)
        material_ids = ordered_materials scope.pluck(:id)
        pdf = combine_pdf_for pdf, material_ids
        pdf.to_pdf
      end
    end
  end
end
