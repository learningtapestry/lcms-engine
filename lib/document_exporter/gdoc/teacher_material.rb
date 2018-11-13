# frozen_string_literal: true

module DocumentExporter
  module Gdoc
    class TeacherMaterial < Gdoc::Base
      FOLDER_NAME = 'Teacher Materials'

      def export
        return gdoc_folder unless @options[:excludes].present?

        scope = @document.teacher_materials
        material_ids = scope.where(id: included_materials(context_type: :gdoc)).pluck(:id)
        gdoc_folder_tmp(material_ids)
      end
    end
  end
end
