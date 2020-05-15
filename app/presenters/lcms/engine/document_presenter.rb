# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentPresenter < Lcms::Engine::ContentPresenter
      PDF_SUBTITLES = { full: '', sm: '_student_materials', tm: '_teacher_materials' }.freeze
      SUBJECT_FULL  = { 'ela' => 'ELA', 'math' => 'Math' }.freeze
      TOC_RESOURCES = [I18n.t('document.toc.tm'), I18n.t('document.toc.sm'), I18n.t('document.toc.credits')].freeze
      TOPIC_FULL    = { 'ela' => 'Unit', 'math' => 'Topic' }.freeze
      TOPIC_SHORT   = { 'ela' => 'U', 'math' => 'T' }.freeze

      def cc_attribution
        core_cc = ld_metadata.cc_attribution
        return core_cc if (fs_cc = fs_metadata.cc_attribution).blank?
        return core_cc if core_cc.casecmp(fs_cc).zero?

        "#{core_cc} #{fs_cc}"
      end

      def color_code
        "#{subject}-base"
      end

      def color_code_grade
        "#{subject}-#{grade}"
      end

      def content_for(context_type, options = {})
        with_excludes = (options[:excludes] || []).any?
        content = render_content(context_type, options)
        content = update_activity_timing(content) if with_excludes
        content = remove_optional_break(content) if ela? && with_excludes
        content
      end

      def description
        ld_metadata.lesson_objective.presence || ld_metadata.description
      end

      def doc_type
        assessment? ? 'assessment' : 'lesson'
      end

      def ela2?
        ela? && grade.to_s == '2'
      end

      def ela6?
        ela? && grade.to_s == '6'
      end

      def fs_metadata
        @fs_metadata ||= DocTemplate::Objects::BaseMetadata.build_from(foundational_metadata)
      end

      def full_breadcrumb(unit_level: false)
        resource ? Breadcrumbs.new(resource).full_title : full_breadcrumb_from_metadata(unit_level)
      end

      def full_breadcrumb_from_metadata(unit_level)
        lesson_level = assessment? ? 'Assessment' : "Lesson #{lesson}" unless unit_level
        [
          SUBJECT_FULL[subject] || subject,
          grade.to_i.zero? ? grade : "Grade #{grade}",
          ll_strand? ? ld_module : "Module #{ld_module.try(:upcase)}",
          topic.present? ? "#{TOPIC_FULL[subject]} #{topic.try(:upcase)}" : nil,
          lesson_level
        ].compact.join(' / ')
      end

      def grade
        ld_metadata.grade[/\d+/] || ld_metadata.grade
      end

      def remove_optional_break(content)
        html = Nokogiri::HTML.fragment content
        html.at_css('.o-ld-optbreak-wrapper')&.remove
        html.to_html
      end

      def ld_metadata
        @ld_metadata ||= DocTemplate::Objects::BaseMetadata.build_from(metadata)
      end

      def ld_module
        ela? ? ld_metadata.module : ld_metadata.unit
      end

      def lesson
        ld_metadata.lesson
      end

      def ll_strand?
        ld_metadata.module =~ /strand/i
      end

      def math_practice
        ld_metadata.lesson_mathematical_practice.squish
      end

      def pdf_header
        "UnboundEd / #{full_breadcrumb}"
      end

      def pdf_filename
        name = short_breadcrumb(join_with: '_', with_short_lesson: true)
        name += PDF_SUBTITLES[content_type.to_sym]
        "#{name}_v#{version.presence || 1}#{Lcms::Engine::ContentPresenter::PDF_EXT}"
      end

      def pdf_footer
        full_breadcrumb
      end

      #
      # Makes sure that time of group is equal to sum of timings of child activities
      #
      def update_activity_timing(content)
        html = Nokogiri::HTML.fragment content
        html.css('.o-ld-group').each do |group|
          group_time = group.css('.o-ld-title__time--h3').inject(0) { |time, section| time + section.text.to_i }
          group.at_css('.o-ld-title__time--h2').content = group_time.zero? ? "\u2014" : "#{group_time} mins"
        end
        html.to_html
      end

      def render_content(context_type, options = {})
        options[:parts_index] = document_parts_index
        rendered_layout = DocumentRenderer::Part.call(layout_content(context_type), options)
        content = DocTemplate.sanitizer.clean_content(rendered_layout, context_type)
        Lcms::Engine::ReactMaterialsResolver.resolve(content, self)
      end

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def short_breadcrumb(join_with: ' / ', with_short_lesson: false, with_subject: true, unit_level: false)
        unless unit_level
          lesson_abbr =
            if assessment?
              with_short_lesson ? 'A' : 'Assessment'
            else
              with_short_lesson ? "L#{lesson}" : "Lesson #{lesson}"
            end
        end
        [
          with_subject ? SUBJECT_FULL[subject] || subject : nil,
          grade.to_i.zero? ? grade : "G#{grade}",
          ll_strand? ? 'LL' : "M#{ld_module.try(:upcase)}",
          topic.present? ? "#{TOPIC_SHORT[subject]}#{topic.try(:upcase)}" : nil,
          lesson_abbr
        ].compact.join(join_with)
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      def short_title
        assessment? ? doc_type : "Lesson #{lesson}"
      end

      def short_url
        @short_url ||= Bitly.client
                         .shorten(Rails.application.routes.url_helpers.document_url(self))
                         .short_url
      end

      def standards
        ld_metadata.standard.presence || ld_metadata.lesson_standard
      end

      def student_materials
        materials.gdoc.where_metadata_any_of(materials_config_for(:student))
      end

      def student_materials_props
        Lcms::Engine::DocumentMaterialSerializer.new(self, student_materials)
      end

      def subject
        ld_metadata&.resource_subject
      end

      def subject_to_str
        SUBJECT_FULL[subject] || subject
      end

      def title
        title = ld_metadata&.title
        resource&.prerequisite? ? "Prerequisite -  #{title}" : title
      end

      def teacher_materials
        materials.gdoc.where_metadata_any_of(materials_config_for(:teacher))
      end

      def teacher_materials_props
        Lcms::Engine::DocumentMaterialSerializer.new(self, teacher_materials)
      end

      def teaser
        ld_metadata.teaser
      end

      def topic
        ela? ? ld_metadata.unit : ld_metadata.topic
      end

      def unit
        @unit ||= resource&.parent
      end
    end
  end
end
