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
            update_level_position_for(grades) { |g| ::Lcms::Engine::Grades.grades.index(g.metadata['grade']) }
          end

          #
          # Fix level position for modules
          # Is used inside `#find_or_create_resource` method
          #
          def update_modules_level_position_for(modules)
            indexes = modules.map(&:short_title).sort_by { |g| g.to_s[NUM_RE].to_i }
            update_level_position_for(modules) { |m| indexes.index(m.metadata['module']) }
          end

          #
          # Fix level position for units
          # Is used inside `#find_or_create_resource` method
          #
          def update_units_level_position_for(units)
            update_level_position_for(units) { |u| u.metadata['unit'][NUM_RE].to_i }
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
            'lesson' => lesson
          }.compact.stringify_keys
        end

        #
        # @return [Lcms::Engine::Resource]
        #
        def find_or_create_resource
          ::Lcms::Engine::Resource.with_advisory_lock('find_or_create_resource') do
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

              set_lesson_position(parent, resource)
            end

            update resource
          end
        end

        private

        def assessment?
          type =~ /assessment/
        end

        def build_new_resource(parent, name, index)
          dir = directory[0..index]
          curriculum_type = parent.nil? ? ::Lcms::Engine::Resource.hierarchy.first : parent.next_hierarchy_level
          resource = ::Lcms::Engine::Resource.new(
            curriculum_type:,
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
          # ELA G1 M1 U2 Lesson 1
          curr ||= directory
          res = ::Lcms::Engine::Resource.new(metadata:)
          ::Lcms::Engine::Breadcrumbs.new(res).title.split(' / ')[0...-1].push(curr.last.to_s.titleize).join(' ')
        end

        def ela?
          subject.to_s.casecmp('ela').zero?
        end

        def grade
          @grade ||= begin
            value = context[:grade].to_s.downcase
            value = "grade #{value.to_i}" if number?(value)
            value # if Grades::GRADES.include?(value)
          end
        end

        def last_item?(index)
          index == directory.size - 1
        end

        def lesson
          @lesson ||= "lesson #{context[:lesson]}"
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

        def opr?
          type.to_s.casecmp('opr').zero?
        end

        def subject
          @subject ||= begin
            value = context[:subject]&.downcase
            value if ::Lcms::Engine::Resource::SUBJECTS.include?(value)
          end
        end

        def tag_list
          [type.presence || 'core']
        end

        def teaser
          context[:teaser]
        end

        def title
          context[:title].presence || default_title
        end

        def type
          context[:type]&.downcase
        end

        def unit
          "unit #{context[:unit]}"
        end

        def update(resource)
          return if resource.nil?

          # Update resource with document metadata
          resource.title = context['title'] if context['title'].present?
          resource.teaser = context['teaser'] if context['teaser'].present?
          resource.description = context['description'] if context['description'].present?
          resource.tag_list << 'opr' if context['type'].to_s.casecmp('opr').to_i.zero?
          resource.save

          resource
        end

        def set_lesson_position(parent, resource)
          next_lesson = parent.children.detect do |r|
            # first lesson with a bigger lesson num
            r.metadata['lesson'].to_s[NUM_RE].to_i > context[:lesson].to_s[NUM_RE].to_i
          end
          next_lesson ? next_lesson.prepend_sibling(resource) : resource.save!
        end
      end
    end
  end
end
