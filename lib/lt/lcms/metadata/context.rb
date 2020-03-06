# frozen_string_literal: true

#
# Handles Document metadata contexts, to find and/or create corresponding Resources
#
module Lt
  module Lcms
    module Metadata
      class Context
        attr_reader :context

        NUM_RE = /\d+/

        class << self
          #
          # Fix level position for grades
          # Is used inside `#find_or_create_resource` method
          #
          def update_grades_level_position_for(grades)
            update_level_position_for(grades) { |m| ::Lcms::Engine::Grades::GRADES.index(m.metadata['grade']) }
          end

          #
          # Fix level position for modules (guidebooks)
          # Is used inside `#find_or_create_resource` method
          #
          def update_modules_level_position_for(modules)
            indexes = modules.map(&:short_title).sort_by { |g| g.to_s[NUM_RE].to_i }
            update_level_position_for(modules) { |m| indexes.index(m.metadata['module']) }
          end

          #
          # Fix level position for units (sections)
          # Is used inside `#find_or_create_resource` method
          #
          def update_units_level_position_for(units)
            update_level_position_for(units) { |m| m.metadata['unit'][NUM_RE].to_i }
          end

          #
          # Fix level position for in case when lower curriculum elements have
          # been created after higher ones: Grade 8 was created before Grade 7
          #
          def update_level_position_for(resources)
            resources
              .map { |m| { id: m.id, idx: yield(m) } }
              .sort_by { |a| a[:idx] }.each_with_index do |data, idx|
                resource = ::Lcms::Engine::Resource.find(data[:id])
                resource.update_columns(level_position: idx) unless resource.level_position == idx
              end
          end
        end

        def initialize(context = {})
          @context = context.with_indifferent_access
        end

        def directory
          @directory ||= [subject, grade, mod, unit, lesson].select(&:present?)
        end

        def metadata
          @metadata ||= {
            'subject' => subject,
            'grade' => grade,
            'module' => mod,
            'unit' => unit,
            'lesson' => lesson,
            'assessment' => (type if assessment?)
          }.compact.stringify_keys
        end

        def find_or_create_resource
          # if the resource exists, return it
          resource = ::Lcms::Engine::Resource.tree.find_by_directory(directory)
          return update(resource) if resource

          # else, build missing parents until we build the resource itself.
          parent = nil
          directory.each_with_index do |name, index|
            resource = ::Lcms::Engine::Resource.tree.find_by_directory(directory[0..index])
            if resource
              parent = resource
              next
            end

            resource = build_new_resource(parent, name, index)
            unless last_item?(index)
              resource.save!
              unless resource.subject?
                self.class.send("update_#{resource.curriculum_type}s_level_position_for", resource.self_and_siblings)
              end
              parent = resource
              next
            end

            if mid_assessment?
              set_mid_assessment_position(parent, resource)
            elsif prerequisite?
              set_prerequisite_position(parent, resource)
            elsif opr?
              set_opr_position(parent, resource)
            else
              set_lesson_position(parent, resource)
            end

            parent = resource
          end

          update resource
        end

        private

        def assessment?
          type =~ /assessment/
        end

        def build_new_resource(parent, name, index)
          dir = directory[0..index]
          curriculum_type = parent.nil? ? ::Lcms::Engine::Resource.hierarchy.first : parent.next_hierarchy_level
          resource = ::Lcms::Engine::Resource.new(
            curriculum_type: curriculum_type,
            level_position: parent&.children&.size.to_i,
            metadata: metadata.to_a[0..index].to_h,
            parent_id: parent&.id,
            resource_type: :resource,
            short_title: name,
            curriculum_id: ::Lcms::Engine::Curriculum.default.id
          )
          if last_item?(index)
            resource.tag_list = tag_list if resource.lesson?
            resource.teaser = teaser
            resource.title = title
          else
            resource.title = default_title(dir)
          end
          resource
        end

        def default_title(curr = nil)
          if assessment?
            mid_assessment? ? 'Mid-Unit Assessment' : 'End-Unit Assessment'
          else
            # ELA G1 M1 U2 Lesson 1
            curr ||= directory
            res = ::Lcms::Engine::Resource.new(metadata: metadata)
            ::Lcms::Engine::Breadcrumbs.new(res).title.split(' / ')[0...-1].push(curr.last.titleize).join(' ')
          end
        end

        def ela?
          subject.to_s.casecmp('ela').zero?
        end

        # TODO: Extract to specific future UnboundEd gem
        def fix_prereq_position(resource)
          next_lesson = resource.siblings.detect do |r|
            break r unless r.prerequisite? # first non-prereq

            # grab the first prereq lesson with a bigger lesson num
            r.lesson_number > context['lesson'].to_i
          end
          next_lesson&.prepend_sibling(resource)
        end

        def grade
          @grade ||= begin
            value = context[:grade].try(:downcase)
            value = "grade #{value.to_i}" if number?(value)
            value # if Grades::GRADES.include?(value)
          end
        end

        def last_item?(index)
          index == directory.size - 1
        end

        def lesson
          @lesson ||= begin
            return nil if assessment? # assessment is a unit now, so lesson -> nil

            num = if ela? && prerequisite?
                    ::Lcms::Engine::RomanNumerals.to_roman(context[:lesson].to_i)&.downcase
                  else
                    context[:lesson].presence
                  end
            "lesson #{num}" if num.present?
          end
        end

        def mid_assessment?
          type.to_s.casecmp('assessment-mid').zero?
        end

        def module
          @module ||= begin
            mod = ela? ? context[:module] : context[:unit]
            alnum?(mod) && !mod.include?('strand') ? "module #{mod.downcase}" : mod
          end
        end
        alias :mod :module # rubocop:disable Style/Alias

        def number?(str)
          str =~ /^\d+$/
        end

        def alnum?(str)
          str =~ /^\w+$/
        end

        # `Optional prerequisite` - https://github.com/learningtapestry/unbounded/issues/557
        def opr?
          type.to_s.casecmp('opr').zero?
        end

        def prerequisite?
          type.to_s.casecmp('prereq').zero?
        end

        def subject
          @subject ||= begin
            value = context[:subject]&.downcase
            value if ::Lcms::Engine::Resource::SUBJECTS.include?(value)
          end
        end

        def tag_list
          assessment? ? ['assessment', type] : [type.presence || 'core'] # lesson => prereq || core
        end

        def teaser
          context[:teaser].presence || (assessment? ? title : nil)
        end

        def title
          context[:title].presence || default_title
        end

        def type
          context[:type]&.downcase
        end

        def unit
          @unit ||= begin
            if assessment?
              type # assessment-mid || assessment-end
            else
              ela? ? "unit #{context[:unit]}" : "topic #{context[:topic]}"
            end
          end
        end

        def update(resource)
          return if resource.nil?

          # if resource changed to prerequisite, fix positioning
          prereq = context['type'].to_s.casecmp('prereq').zero?
          fix_prereq_position(resource) if prereq && !resource.prerequisite?

          # Update resource with document metadata
          resource.title = context['title'] if context['title'].present?
          resource.teaser = context['teaser'] if context['teaser'].present?
          resource.description = context['description'] if context['description'].present?
          resource.tag_list << 'prereq' if prereq
          resource.tag_list << 'opr' if context['type'].to_s.casecmp('opr').zero?
          resource.save

          resource
        end

        def set_mid_assessment_position(parent, resource)
          unit = parent.children.detect { |r| r.short_title =~ /topic #{context['after-topic']}/i }
          unit.append_sibling(resource)
        end

        def set_prerequisite_position(parent, resource)
          next_lesson = parent.children.detect do |r|
            break r unless r.prerequisite? # first non-prereq

            # first prereq lesson with a bigger lesson num
            r.lesson_number > context[:lesson].to_i
          end
          next_lesson&.prepend_sibling(resource)
        end

        def set_opr_position(parent, resource)
          first_non_opr = parent.children.detect { |r| !r.opr? }
          first_non_opr&.prepend_sibling(resource)
        end

        def set_lesson_position(parent, resource)
          next_lesson = parent.children.detect do |r|
            # first lesson with a bigger lesson num
            r.lesson_number > context[:lesson].to_i
          end
          next_lesson ? next_lesson.prepend_sibling(resource) : resource.save!
        end
      end
    end
  end
end
