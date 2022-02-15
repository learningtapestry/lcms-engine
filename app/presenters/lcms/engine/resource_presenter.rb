# frozen_string_literal: true

module Lcms
  module Engine
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
          downloads_list = Lcms::Engine::DownloadCategory.all.map do |dc|
            downloads = Array.wrap(download_categories[dc.title])
            downloads.concat(document_bundles) if dc.bundle?
            settings = download_categories_settings[dc.title.parameterize] || {}

            next unless settings.values.any? || downloads.any?

            data = { category: dc, title: dc.title, downloads: downloads, settings: settings }
            Struct.new(*data.keys, keyword_init: true).new(data)
          end

          if (uncategorized = download_categories['']).present?
            data = { downloads: uncategorized, settings: {} }
            downloads_list << Struct.new(*data.keys, keyword_init: true).new(data)
          end

          downloads_list.compact
        end
      end
    end
  end
end
