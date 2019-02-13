# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentBundle < ActiveRecord::Base
      CATEGORIES = %w(full tm sm).freeze
      CONTENT_TYPES = %w(pdf gdoc).freeze

      belongs_to :resource

      mount_uploader :file, DocumentBundleUploader

      validates :resource, :category, presence: true
      validates :category, inclusion: { in: CATEGORIES }
      validates :content_type, inclusion: { in: CONTENT_TYPES }

      def self.update_bundle(resource, category = 'full')
        update_pdf_bundle(resource, category)
        update_gdoc_bundle(resource) if category == 'full'
      end

      def self.update_pdf_bundle(resource, category)
        zip_path = LessonsPdfBundler.new(resource, category).bundle
        return unless File.exist?(zip_path.to_s)

        begin
          doc_bundle = find_or_create_by(resource: resource, category: category, content_type: 'pdf')

          File.open(zip_path) do |f|
            doc_bundle.file = f
            doc_bundle.save!
          end
        ensure
          FileUtils.rm(zip_path)
        end
      end
      private_class_method :update_pdf_bundle

      def self.update_gdoc_bundle(resource)
        return unless resource.unit?

        bundle_path = LessonsGdocBundler.new(resource).bundle
        return unless bundle_path

        doc_bundle = find_or_create_by(resource: resource, category: 'full', content_type: 'gdoc')
        doc_bundle.url = bundle_path
        doc_bundle.save!
      end
      private_class_method :update_gdoc_bundle
    end
  end
end
