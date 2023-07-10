# frozen_string_literal: true

require 'lt/lcms/lesson/downloader/gdoc'
require 'lt/lcms/lesson/downloader/pdf'

module Lcms
  module Engine
    class MaterialBuildService
      EVENT_BUILT = 'material:built'
      PDF_EXT_RE = /\.pdf$/

      attr_reader :errors

      def initialize(credentials, opts = {})
        @credentials = credentials
        @errors = []
        @options = opts
      end

      def build(url)
        @url = url
        result = pdf? ? build_from_pdf : build_from_gdoc
        ActiveSupport::Notifications.instrument EVENT_BUILT, id: result.id
        result
      end

      private

      attr_reader :credentials, :material, :downloader, :options, :url

      def build_from_pdf # rubocop:disable Metrics/AbcSize
        @downloader = ::Lt::Lcms::Lesson::Downloader::PDF.new(credentials, url)
        create_material
        title = @downloader.file.name.sub(PDF_EXT_RE, '')
        identifier = "#{title.downcase}#{ContentPresenter::PDF_EXT}"

        metadata = DocTemplate::Objects::MaterialMetadata.build_from_pdf(identifier:, title:).as_json
        material.update!(
          material_params.merge(
            identifier:,
            metadata:
          )
        )

        material.document_parts.delete_all

        basename = DocumentGenerator.material_presenter.new(material).material_filename
        pdf_filename = "#{basename}#{ContentPresenter::PDF_EXT}"
        thumb_filename = "#{basename}#{ContentPresenter::THUMB_EXT}"

        pdf = @downloader.pdf_content
        thumb_exporter = DocumentExporter::Thumbnail.new(pdf)
        thumb = thumb_exporter.export
        material.metadata['orientation'] = thumb_exporter.orientation
        material.metadata['pdf_url'] = S3Service.upload pdf_filename, pdf
        material.metadata['thumb_url'] = S3Service.upload thumb_filename, thumb
        material.save
        material
      end

      def build_from_gdoc
        @downloader = ::Lt::Lcms::Lesson::Downloader::Gdoc.new(@credentials, url, options)
        create_material
        content = @downloader.download.content
        template = DocTemplate::Template.parse(content, type: :material)
        @errors = template.metadata_service.errors

        metadata = template.metadata_service.options_for(:default)[:metadata]
        material.update!(
          material_params.merge(
            css_styles: template.css_styles,
            identifier: metadata['identifier'].downcase,
            metadata: metadata.as_json,
            original_content: content
          )
        )

        material.document_parts.delete_all
        material.create_parts_for(template)
        material
      end

      def create_material
        @material = Material.find_or_initialize_by(file_id: downloader.file_id)
      end

      def material_params
        {
          last_modified_at: downloader.file.modified_time,
          last_author_email: downloader.file.last_modifying_user.try(:email_address),
          last_author_name: downloader.file.last_modifying_user.try(:display_name),
          name: downloader.file.name,
          reimported_at: Time.current,
          version: downloader.file.version
        }
      end

      def pdf?
        return options[:source_type].casecmp('pdf').zero? if options[:source_type].present?

        dl = ::Lt::Lcms::Lesson::Downloader::Base.new credentials, url
        dl.file.name.to_s =~ PDF_EXT_RE
      end
    end
  end
end
