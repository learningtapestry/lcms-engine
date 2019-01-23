# frozen_string_literal: true

require 'lt/lcms/lesson/downloader/gdoc'
require 'lt/lcms/lesson/downloader/pdf'

class MaterialBuildService
  PDF_EXT_RE = /\.pdf$/

  def initialize(credentials, opts = {})
    @credentials = credentials
    @options = opts
  end

  def build(url)
    @url = url
    pdf? ? build_from_pdf : build_from_gdoc
  end

  private

  attr_reader :credentials, :material, :downloader, :options, :url

  def build_from_pdf
    @downloader = ::Lt::Lcms::Lesson::Downloader::PDF.new(credentials, url)
    create_material
    title = @downloader.file.name.sub(PDF_EXT_RE, '')
    identifier = "#{title.downcase}#{ContentPresenter::PDF_EXT}"

    material.update!(
      material_params.merge(
        identifier: identifier,
        metadata: DocTemplate::Objects::MaterialMetadata.build_from_pdf(identifier: identifier, title: title).to_json
      )
    )

    material.material_parts.delete_all

    basename = MaterialPresenter.new(material).material_filename
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

    metadata = template.metadata_service.options_for(:default)[:metadata]
    material.update!(
      material_params.merge(
        css_styles: template.css_styles,
        identifier: metadata['identifier'].downcase,
        metadata: metadata.to_json,
        original_content: content
      )
    )

    material.material_parts.delete_all

    presenter = MaterialPresenter.new(material, parsed_document: template)
    DocTemplate.context_types.each do |context_type|
      material.material_parts.create!(
        active: true,
        content: presenter.render_content(context_type),
        context_type: context_type,
        part_type: :layout
      )
    end
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
