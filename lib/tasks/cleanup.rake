# frozen_string_literal: true

require 'google/apis/drive_v3'
require 'lt/google/api/auth/cli'

namespace :cleanup do # rubocop:disable Metrics/BlockLength
  namespace :materials do # rubocop:disable Metrics/BlockLength
    def reset_links_for(type)
      Material.find_each do |material|
        next if material.preview_links.empty?

        links = material.preview_links
        links.delete(type.to_s)
        material.update preview_links: links
      end
    end

    def credentials
      ::Lt::Google::Api::Auth::Cli.new.credentials
    end

    desc 'cleans up PDF generated for materials preview'
    task pdf: :environment do
      reset_links_for :pdf

      Aws::S3::Resource
        .new(region: ENV.fetch('AWS_REGION'))
        .bucket(ENV.fetch('AWS_S3_BUCKET_NAME'))
        .objects(prefix: MaterialPreviewGenerator::PDF_S3_FOLDER)
        .batch_delete!
    end

    desc 'cleans up PDF generated for materials preview'
    task gdoc: :environment do
      reset_links_for :gdoc

      folder_id = ENV.fetch('GOOGLE_APPLICATION_PREVIEW_FOLDER_ID')

      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = credentials
      service
        .list_files(q: "'#{folder_id}' in parents")
        .files.each { |file| service.delete_file file.id }
    end
  end
end
