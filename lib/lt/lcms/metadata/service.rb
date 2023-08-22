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
                  metadata: DocTemplate::Objects::BaseMetadata.build_from(metadata.data),
                  parts: @target_table.try(:parts)
                }
              end
            )
          end

          def parse(content, *args) # rubocop:disable Metrics/PerceivedComplexity
            super
            if material?
              @metadata = DocTemplate::Tables::MaterialMetadata.parse content
              @errors.concat @metadata.errors
              raise ::Lcms::Engine::MaterialError, 'No metadata present' \
                if !@metadata&.table_exist? || @metadata&.data&.empty?
            else
              @metadata = DocTemplate::Tables::Metadata.parse content
              @errors.concat @metadata.errors
              raise ::Lcms::Engine::DocumentError, 'No metadata present' unless @metadata&.table_exist?

              @section_metadata = DocTemplate::Tables::Section.parse content
              @activity_metadata = DocTemplate::Tables::Activity.parse(content)
              @target_table = DocTemplate::Tables::Target.parse(content) if target_table?
            end

            self
          end

          private

          def lesson_options
            {
              activity: DocTemplate::Objects::ActivityMetadata.build_from(@activity_metadata),
              sections: DocTemplate::Objects::SectionsMetadata.build_from(@section_metadata)
            }
          end

          def target_table?
            return false unless metadata.present?

            metadata.data['subject']&.downcase == 'ela' && metadata.data['grade'] == '6'
          end
        end
      end
    end
  end
end
