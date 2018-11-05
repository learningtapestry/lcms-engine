# frozen_string_literal: true

class ResourcePresenter < SimpleDelegator
  def subject_and_grade_title
    "#{subject.try(:titleize)} #{grades.list.first.try(:titleize)}"
  end

  def page_title
    grade_avg = grades.average || 'base'
    grade_code = grade_avg.include?('k') ? grade_avg : "G#{grade_avg}"
    "#{subject.try(:upcase)} #{grade_code.try(:upcase)}: #{title}"
  end

  def downloads_indent(opts = {})
    pdf_downloads?(opts[:category]) ? 'u-li-indent' : ''
  end

  def categorized_downloads_list
    @categorized_downloads_list ||= begin
      downloads_list = DownloadCategory.all.map do |dc|
        downloads = Array.wrap(download_categories[dc.title])
        downloads.concat(document_bundles) if dc.bundle?
        settings = download_categories_settings[dc.title.parameterize] || {}

        next unless settings.values.any? || downloads.any?

        OpenStruct.new(category: dc, title: dc.title, downloads: downloads, settings: settings)
      end

      uncategorized = download_categories['']
      downloads_list << OpenStruct.new(downloads: uncategorized, settings: {}) if uncategorized.present?

      downloads_list.compact
    end
  end
end
