# frozen_string_literal: true

# This is a superset of ResourceSerializer, meant to be used were we need
# associations and other info. Currently is used on ExploreCurriculums
# (together with the CurriculumResourceSerializer)
class ResourceDetailsSerializer < ResourceSerializer
  include ResourceHelper

  self.root = false

  attributes :breadcrumb_title, :copyright, :downloads, :grade, :has_related, :id,
             :opr_description, :opr_standards, :path, :short_title, :subject, :teaser, :time_to_teach,
             :title, :type

  def downloads
    serialize_download = lambda do |download|
      next unless download.is_a?(ResourceDownload)

      indent = object.pdf_downloads? download.download_category
      {
        id: download.id,
        icon: h.file_icon(download.download.attachment_content_type),
        title: download.download.title,
        url: download_path(download, slug: object.slug),
        preview_url: preview_download_path(id: download, slug: object.slug),
        indent: indent
      }
    end
    object.download_categories.map { |k, v| [k, v.map(&serialize_download)] }
  end

  def copyright
    copyrights_text(object)
  end

  def has_related # rubocop:disable Naming/PredicateName
    false
  end

  def opr_standards
    return unless object.opr? && object.document.present?

    DocumentPresenter.new(object.document).standards
  end

  private

  def h
    ApplicationController.helpers
  end
end
