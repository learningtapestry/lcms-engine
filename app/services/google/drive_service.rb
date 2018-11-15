# frozen_string_literal: true

module Google
  class DriveService < ::Lt::Google::Api::Drive
    include GoogleCredentials

    FOLDER_ID = ENV.fetch('GOOGLE_APPLICATION_FOLDER_ID', 'PLEASE SET UP FOLDER ID')

    attr_reader :service

    def self.build(document, options = {})
      new document, options
    end

    def copy(file_ids, folder_id = parent)
      super file_ids, folder_id
    end

    def create_folder(folder_name, parent_id = FOLDER_ID)
      super folder_name, parent_id
    end

    def initialize(document, options)
      super google_credentials
      @document = document
      @options = options
    end

    def file_id
      @file_id ||= begin
        file_name = document.base_filename
        response = service.list_files(
          q: "'#{parent}' in parents and name = '#{file_name}' and mimeType = '#{MIME_FILE}' and trashed = false",
          fields: 'files(id)'
        )
        return nil if response.files.empty?

        unless response.files.size == 1
          Rails.logger.warn "Multiple files: more than 1 file with same name: #{file_name}"
        end
        response.files[0].id
      end
    end

    def parent
      @parent ||=
        begin
          subfolders = (options[:subfolders] || []).unshift(options[:gdoc_folder] || document.gdoc_folder)
          parent_folder = FOLDER_ID
          subfolders.each do |folder|
            parent_folder = subfolder(folder, parent_folder)
          end
          parent_folder
        end
    end

    private

    attr_reader :document, :options

    def folder_query(folder_name, parent_id)
      query = %(
        '#{parent_id}' in parents and name = '#{folder_name}' and
        mimeType = '#{::Lt::Google::Api::Drive::MIME_FOLDER}' and
        trashed = false)
      service.list_files(
        q: query,
        fields: 'files(id)'
      )
    end

    def subfolder(folder_name, parent_id = FOLDER_ID)
      response = folder_query folder_name, parent_id
      files = response.files
      return create_folder(folder_name, parent_id) if files.empty?

      Rails.logger.warn "Multiple folders: more than 1 folder with same name: #{folder_name}" if files.size > 1
      response.files[0].id
    end
  end
end
