# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentForm
      include Virtus.model
      include ActiveModel::Model
      include Lcms::Engine::GoogleCredentials

      attribute :link, String
      attribute :link_fs, String

      validates_presence_of :link, if: -> { link_fs.blank? }
      validates_presence_of :link_fs, if: -> { link.blank? }

      attr_reader :document

      def initialize(attributes = {}, opts = {})
        @is_reimport = attributes.delete(:reimport).present? || false
        super(attributes)
        @options = opts
      end

      def save
        return false unless valid?

        @document = build_document
        after_reimport_hook
        @document.update(reimported: true)
      rescue StandardError => e
        @document&.update(reimported: false)
        Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
        errors.add(:link, e.message)
        false
      end

      private

      attr_reader :is_reimport, :options

      def after_reimport_hook
        DocumentGenerator.generate_for(@document)
      end

      def build_document
        service = document_build_service

        if is_reimport
          doc = service.build_for(link)
          doc = service.build_for(link_fs, expand: true) if link_fs.present?
          doc
        elsif (full_doc = find_full_document)
          # if there is a document with the same file_id or foundational_file_id
          # we need to make full re-import to correctly handle expand process
          service.build_for(full_doc.file_url)
          service.build_for(full_doc.file_fs_url, expand: true)
        else
          service.build_for link
        end
      end

      def document_build_service
        DocumentBuildService.new(google_credentials, import_retry: options[:import_retry])
      end

      def find_full_document
        id = file_id

        doc = Document.actives.find_by(file_id: id)
        return doc if doc&.foundational_file_id.present?

        doc = Document.actives.find_by(foundational_file_id: id)
        doc if doc&.file_id.present?
      end

      def file_id
        ::Lt::Lcms::Lesson::Downloader::Base.file_id_for link
      end
    end
  end
end
