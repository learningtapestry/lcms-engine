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
    end
  end
end
