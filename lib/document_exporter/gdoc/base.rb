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
          send_timeout_sec: GOOGLE_API_CLIENT_UPLOAD_TIMEOUT
        }
      }.freeze
      GOOGLE_API_RATE_RETRIABLE_ERRORS = [Google::Apis::ServerError, Google::Apis::RateLimitError].freeze
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
        metadata = Google::Apis::DriveV3::File.new(file_params)

        params = {
          content_type: 'text/html',
          upload_source: StringIO.new(content)
        }.merge(GOOGLE_API_UPLOAD_OPTIONS)

        # use general API settings for inner API call and wrap it with additional retry logic
        @id = Retriable.retriable(base_interval: ENV.fetch('GOOGLE_API_CLIENT_UPLOAD_RATE_BASE_INTERVAL', 5).to_i,
                                  multiplier: ENV.fetch(
                                    'GOOGLE_API_CLIENT_UPLOAD_RATE_MULTIPLIER', 2
                                  ).to_f,
                                  max_interval: ENV.fetch(
                                    'GOOGLE_API_CLIENT_UPLOAD_RATE_MAX_INTERVAL', 300
                                  ).to_i,
                                  max_elapsed_time: ENV.fetch('GOOGLE_API_CLIENT_UPLOAD_RATE_MAX_ELAPSED_TIME',
                                                              900).to_i,
                                  on_retry: log_retries(file_id, metadata),
                                  tries: GOOGLE_API_CLIENT_UPLOAD_RETRIES) do
          if file_id.present?
            drive_service.service.update_file(file_id, metadata, params)
          else
            drive_service.service.create_file(metadata, params)
          end.id
        end

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

        @id = Retriable.retriable(base_interval: ENV.fetch('GOOGLE_API_CLIENT_UPLOAD_RATE_BASE_INTERVAL', 5).to_i,
                                  multiplier: ENV.fetch(
                                    'GOOGLE_API_CLIENT_UPLOAD_RATE_MULTIPLIER', 2
                                  ).to_f,
                                  max_interval: ENV.fetch(
                                    'GOOGLE_API_CLIENT_UPLOAD_RATE_MAX_INTERVAL', 300
                                  ).to_i,
                                  max_elapsed_time: ENV.fetch('GOOGLE_API_CLIENT_UPLOAD_RATE_MAX_ELAPSED_TIME',
                                                              900).to_i,
                                  on_retry: log_retries(file_id, metadata),
                                  tries: GOOGLE_API_CLIENT_UPLOAD_RETRIES) do
          if file_id.present?
            drive_service.service.update_file(file_id, metadata, params)
          else
            drive_service.service.create_file(metadata, params)
          end.id
        end

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
        render_template template_path('show'), layout: 'ld_gdoc'
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
          document.links['materials']&.dig(id.to_s, 'gdoc')&.gsub(/.*id=/, '')
        end

        @options[:subfolders] = [self.class::FOLDER_NAME]
        @id = drive_service.copy(file_ids)
        self
      end

      def log_retries(file_id, metadata)
        proc do |exception, try, elapsed_time, next_interval|
          msg = "#{exception.class}: '#{exception.message}' - #{try} tries in #{elapsed_time} seconds " \
                "and #{next_interval} seconds until the next try. " \
                "File ID: #{file_id}, Metadata: #{metadata.inspect}"
          Rails.logger.error(msg)
          if defined?(Airbrake) && ENV.fetch('AIRBRAKE_UPLOAD_ERRORS_NOTIFY', 'off') == 'on'
            ::Airbrake.notify_sync(Airbrake.build_notice(msg)) do |notice|
              notice[:context][:severity] = 'warning'
            end
          end
        end
      end

      def post_processing
        Retriable.retriable(base_interval: 5, tries: 10) do
          Lcms::Engine::Google::ScriptService.new(document).execute(@id)
        end
      end
    end
  end
end
