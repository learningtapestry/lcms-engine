# frozen_string_literal: true

require 'lt/lcms/lesson/downloader/gdoc'

module Lcms
  module Engine
    class DocumentBuildService
      EVENT_BUILT = 'document:built'

      attr_reader :errors

      def initialize(credentials, opts = {})
        @credentials = credentials
        @errors = []
        @options = opts
      end

      #
      # @param [String] url
      # @return [Lcms::Engine::Document]
      #
      def build_for(url)
        @content = download url
        @template = DocTemplate::Template.parse @content
        @errors = @template.metadata_service.errors

        @document = create_document
        @document.update!(original_content: content)

        clear_preview_link
        build

        @document.create_parts_for(template)

        ActiveSupport::Notifications.instrument(EVENT_BUILT, id: document.id)

        document.activate!
        document
      end

      private

      attr_reader :credentials, :content, :document, :downloader, :options, :template

      #
      # Building the document. Handles workflow:
      # Core-first FS-second and FS-first Core-second.
      #
      def build
        document.document_parts.delete_all
        document.update! document_params.merge(toc: template.toc, material_ids: template.toc.collect_material_ids)
      end

      def build_params
        params = document_params.merge(fs_name: document.name, name: downloader.file.name)
        params[:toc] = document.toc
        params[:material_ids] = params[:toc].collect_material_ids
        params
      end

      def clear_preview_link
        links = document.links
        links['pdf']&.delete('preview')
        document.links = links
      end

      #
      # Initiate or update existing document:
      # - fills in original contents
      # - stores specific file_id
      #
      def create_document
        doc = find_resource
        doc[:file_id] = downloader.file_id if doc.present?
        doc || Document.actives.find_or_initialize_by(file_id: downloader.file_id)
      end

      def document_params
        {
          activity_metadata: template.metadata_service.try(:activity_metadata),
          css_styles: template.css_styles,
          name: downloader.file.name,
          last_modified_at: downloader.file.modified_time,
          last_author_email: downloader.file.last_modifying_user.try(:email_address),
          last_author_name: downloader.file.last_modifying_user.try(:display_name),
          metadata: template.metadata,
          reimported_at: Time.current,
          sections_metadata: template.metadata_service.try(:section_metadata),
          version: downloader.file.version
        }
      end

      def download(url)
        @downloader = ::Lt::Lcms::Lesson::Downloader::Gdoc.new(credentials, url, options).download
        @downloader.content
      end

      def find_resource
        context = DocTemplate.config.dig('metadata', 'context').constantize
        dir = context.new(template.metadata.with_indifferent_access).directory
        Resource.find_by_directory(dir)&.document
      end
    end
  end
end
