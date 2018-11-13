# frozen_string_literal: true

module DocumentExporter
  module Gdoc
    class Material < Gdoc::Base
      def export
        @options[:subfolders] = [DocumentExporter::Gdoc::StudentMaterial::FOLDER_NAME] if document.student_material?
        @options[:subfolders] = [DocumentExporter::Gdoc::TeacherMaterial::FOLDER_NAME] if document.teacher_material?
        unless @options.key?(:subfolders)
          Rails.logger.warn "Material belongs neither to teachers nor to students: #{document.id}"
          @options[:subfolders] = ['Materials']
        end

        handle_vertical_text if document.vertical_text?

        super
      end

      private

      def handle_vertical_text
        data = TextToImage.new(vertical_text, rotate: -90).raw
        filename = "documents/#{document.base_filename}-vtext.png"
        url = S3Service.upload filename, data
        @options[:vertical_text_image_url] = url
      end

      def template_path(name)
        File.join('documents', 'gdoc', 'materials', name)
      end

      def vertical_text_image_data
        TextToImage.new(vertical_text, rotate: -90).raw
      end

      def vertical_text
        document.metadata['vertical_text']
      end
    end
  end
end
