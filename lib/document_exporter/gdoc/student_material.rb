# frozen_string_literal: true

module DocumentExporter
  module Gdoc
    class StudentMaterial < Gdoc::Base
      FOLDER_NAME = 'Student Materials'

      def export
        return gdoc_folder unless @options[:excludes].present?

        scope = @document.student_materials
        material_ids = scope.where(id: included_materials(context_type: :gdoc)).pluck(:id)
        gdoc_folder_tmp(material_ids)
      end
    end
  end
end
