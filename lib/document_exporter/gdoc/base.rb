# frozen_string_literal: true

require 'google/apis/drive_v3'
require 'google/apis/script_v1'

module DocumentExporter
  module Gdoc
    class Base < DocumentExporter::Base
      GOOGLE_API_CLIENT_UPLOAD_RETRIES = ENV.fetch('GOOGLE_API_CLIENT_UPLOAD_RETRIES', 5).to_i
      GOOGLE_API_CLIENT_UPLOAD_TIMEOUT = ENV.fetch('GOOGLE_API_CLIENT_UPLOAD_TIMEOUT', 60).to_i
      GOOGLE_API_UPLOAD_OPTIONS = {
        options: {
          open_timeout_sec: GOOGLE_API_CLIENT_UPLOAD_TIMEOUT,
          read_timeout_sec: GOOGLE_API_CLIENT_UPLOAD_TIMEOUT,
          retries: GOOGLE_API_CLIENT_UPLOAD_RETRIES,
          send_timeout_sec: GOOGLE_API_CLIENT_UPLOAD_TIMEOUT
        }
      }.freeze
      VERSION_RE = /_v\d+$/i

      attr_reader :document, :options

      class << self
        def gdoc_key(type)
          "gdoc_#{type}"
        end

        def url_for(file_id)
          "https://drive.google.com/open?id=#{file_id}"
        end
      end

      def create_gdoc_folders(folder)
        id = drive_service.create_folder(folder)
        folders = [id]
        folders << drive_service.create_folder(DocumentExporter::Gdoc::TeacherMaterial::FOLDER_NAME, id)
        folders << drive_service.create_folder(DocumentExporter::Gdoc::StudentMaterial::FOLDER_NAME, id)
        folders.each(&method(:delete_previous_versions_from))
      end

      def export
        file_id = @options[:file_id] || drive_service.file_id
        parent_folder = file_id.blank? ? @options[:folder_id] || drive_service.parent : nil

        file_name = "#{@options[:prefix]}#{document.base_filename}"
        file_params = { name: file_name, mime_type: 'application/vnd.google-apps.document' }
        file_params[:parents] = [parent_folder] if parent_folder.present?
        metadata = Google::Apis::DriveV3::File.new(**file_params)

        params = {
          content_type: 'text/html',
          upload_source: StringIO.new(content)
        }.merge(GOOGLE_API_UPLOAD_OPTIONS)

        @id = if file_id.blank?
                drive_service.service.create_file(metadata, **params)
              else
                drive_service.service.update_file(file_id, metadata, **params)
              end.id

        post_processing

        self
      end

      #
      # @param folder_id String ID of folder export file to
      # @param file_id String ID of existing file
      #
      def export_to(folder_id, file_id: nil)
        metadata = Google::Apis::DriveV3::File.new(
          name: document.base_filename(with_version: false),
          mime_type: 'application/vnd.google-apps.document',
          parents: [folder_id]
        )

        params = {
          content_type: 'text/html',
          upload_source: StringIO.new(content)
        }.merge(GOOGLE_API_UPLOAD_OPTIONS)

        @id = if file_id.present?
                drive_service.service.update_file(file_id, metadata, **params)
              else
                drive_service.service.create_file(metadata, **params)
              end.id

        post_processing

        self
      end

      def url
        self.class.url_for @id
      end

      private

      def base_path(name)
        File.join('documents', 'gdoc', name)
      end

      def content
        render_template template_path('show'), layout: 'gdoc'
      end

      #
      # Deletes files of previous versions
      #
      def delete_previous_versions_from(folder)
        files = drive_service.service.list_files(q: "'#{folder}' in parents")&.files
        Array.wrap(files).each do |file|
          next unless file.name =~ VERSION_RE

          drive_service.service.delete_file file.id
        end
      end

      def drive_service
        @drive_service ||= Lcms::Engine::Google::DriveService.build(document, options)
      end

      def gdoc_folder
        @options[:subfolders] = [self.class::FOLDER_NAME] if defined?(self.class::FOLDER_NAME)
        @id = drive_service.parent
        self
      end

      def gdoc_folder_tmp(material_ids)
        file_ids = material_ids.map do |id|
          document.links['materials']&.dig(id.to_s)&.dig('gdoc')&.gsub(/.*id=/, '')
        end

        @options[:subfolders] = [self.class::FOLDER_NAME]
        @id = drive_service.copy(file_ids)
        self
      end

      def post_processing
        Retriable.retriable(base_interval: 5, tries: 10) do
          Lcms::Engine::Google::ScriptService.new(document).execute(@id)
        end
      end
    end
  end
end
