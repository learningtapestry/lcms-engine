# frozen_string_literal: true

require 'google/apis/drive_v3'

module DocumentDownloader
  class Base
    GDRIVE_FOLDER_RE = %r{/drive/(.*/)?folders/([^\/]+)/?}

    def self.file_id_for(url)
      url.scan(%r{/d/([^\/]+)/?}).first.try(:first) ||
        url.scan(%r{/open\?id=([^\/]+)/?}).first.try(:first)
    end

    def self.list_files(folder_url, google_credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = google_credentials

      files = []
      folder_url.match(GDRIVE_FOLDER_RE) { |m| files.concat list_files_iter(m[2], service) }
      files.map { |f| gdoc_file_url(f.id) }
    end

    def self.list_files_iter(folder_id, service)
      files = []
      page_token = nil
      loop do
        result = service.list_files(
          q: "'#{folder_id}' in parents",
          fields: 'files(id, mime_type), nextPageToken',
          page_token: page_token
        )

        result.files.each do |f|
          case f.mime_type
          when self::MIME_TYPE then files << f
          when 'application/vnd.google-apps.folder' then files.concat list_files_iter(f.id, service)
          end
        end

        page_token = result.next_page_token
        break if page_token.nil?
      end
      files.flatten
    end

    attr_reader :content

    def initialize(credentials, file_url, opts = {})
      @credentials = credentials
      @file_url = file_url
      @options = opts
    end

    def file
      @file ||= service.get_file(
        file_id, fields: 'lastModifyingUser,modifiedTime,name,version'
      )
    end

    def file_id
      @file_id ||= self.class.file_id_for @file_url
    end

    private

    attr_reader :options

    def service
      return @_service if @_service.present?

      @_service = Google::Apis::DriveV3::DriveService.new
      @_service.authorization = @credentials
      @_service
    end
  end
end
