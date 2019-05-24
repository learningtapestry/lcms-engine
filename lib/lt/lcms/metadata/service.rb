# frozen_string_literal: true

# TODO: Move to lt-lcms gem
module Lt
  module Lcms
    module Metadata
      class Service < BaseService
        class << self
          def agenda
            @agenda.data.presence || []
          end

          def foundational_metadata
            @foundational_metadata.data.presence || {}
          end

          def materials_metadata
            DocTemplate::Objects::MaterialMetadata
          end

          def options_for(context)
            super.merge(
              if material?
                {
                  metadata: DocTemplate::Objects::MaterialMetadata.build_from(metadata.data),
                  material: true
                }
              else
                {
                  foundational_metadata: DocTemplate::Objects::BaseMetadata.build_from(@foundational_metadata.data),
                  metadata: DocTemplate::Objects::BaseMetadata.build_from(metadata.data),
                  parts: @target_table.try(:parts)
                }
              end
            )
          end

          def parse(content, *args)
            super
            if material?
              @metadata = DocTemplate::Tables::MaterialMetadata.parse content
              raise ::MaterialError, 'No metadata present' if !@metadata&.table_exist? || @metadata&.data&.empty?
            else
              @metadata = DocTemplate::Tables::Metadata.parse content
              raise ::DocumentError, 'No metadata present' unless @metadata&.table_exist?

              @agenda = DocTemplate::Tables::Agenda.parse content
              @section_metadata = DocTemplate::Tables::Section.parse content,
                                                                     force_inject_section: force_inject_section?
              @activity_metadata = DocTemplate::Tables::Activity.parse content, template_type: template_type
              @target_table = DocTemplate::Tables::Target.parse(content) if target_table?

              @foundational_metadata = if foundational?
                                         @metadata
                                       else
                                         DocTemplate::Tables::FoundationalMetadata.parse content
                                       end
            end

            self
          end

          private

          #
          # Force injecting of Section metadata only if there are no Agenda tables
          #
          def force_inject_section?
            @agenda.data.empty? && metadata.data.any?
          end

          def foundational?
            metadata.data['type'].to_s.casecmp('fs').zero?
          end

          def lesson_options
            {
              activity: DocTemplate::Objects::ActivityMetadata.build_from(@activity_metadata),
              agenda: DocTemplate::Objects::AgendaMetadata.build_from(@agenda.data),
              sections: DocTemplate::Objects::SectionsMetadata.build_from(@section_metadata, template_type)
            }
          end

          def target_table?
            return false unless metadata.present?

            metadata.data['subject']&.downcase == 'ela' && metadata.data['grade'] == '6'
          end

          def template_type
            foundational? ? 'fs' : 'core'
          end
        end
      end
    end
  end
end
