# frozen_string_literal: true

require 'virtus'

module Lcms
  module Engine
    module Search
      class Document < ElasticSearchDocument
        include Virtus.model

        METADATA_FIELDS = %w(description teaser title lesson_objective).freeze

        attribute :breadcrumbs, String
        attribute :description, String
        attribute :doc_type, String
        attribute :document_metadata, String
        attribute :grade, String
        attribute :id, String
        attribute :model_id, Integer
        attribute :model_type, String
        attribute :permalink, String
        attribute :position, String
        attribute :slug, String
        attribute :subject, String
        attribute :tag_authors, Array[String]
        attribute :tag_keywords, Array[String]
        attribute :tag_standards, Array[String]
        attribute :tag_texts, Array[String]
        attribute :teaser, String
        attribute :title, String

        class << self
          def build_from(model)
            if model.is_a?(Lcms::Engine::Resource)
              new(**attrs_from_resource(model))

            elsif model.is_a?(Lcms::Engine::ExternalPage)
              new(**attrs_from_page(model))

            else
              raise "Unsupported Type for Search : #{model.class.name}"
            end
          end

          def doc_type(model)
            model.resource_type == 'resource' ? model.curriculum_type : model.resource_type
          end

          def document_metadata(model)
            return unless model.document?

            METADATA_FIELDS.map do |k|
              value = model.document.metadata[k]
              Nokogiri::HTML.fragment(value).text.presence
            end.compact.join(' ')
          end

          # Position mask:
          # - Since lessons uses 4 blocks of 2 numbers for (grade, mod, unit, lesson),
          #   we use 5 blocks to place them after lessons.
          # - the first position is realted to the resource type (always starting
          #   with 9 to be placed after the lessons).
          # - The second most significant is related to the grade
          # - The last position is the number of different grades covered, i.e:
          #   a resource with 3 different grades show after one with 2, (more specific
          #   at the top, more generic at the bottom)
          def grade_position(model)
            if model.is_a?(Lcms::Engine::Resource) && model.generic?
              rtype = model[:resource_type] || 0
              # for generic resource use the min grade, instead the avg
              grade_pos = model.grades.list.map { |g| Lcms::Engine::Grades::GRADES.index(g) }.compact.min || 0
              last_pos = model.grades.list.size
            else
              rtype = 0
              grade_pos = model.grades.average_number
              last_pos = 0
            end
            first_pos = 90 + rtype

            [first_pos, grade_pos, 0, 0, last_pos].map { |n| n.to_s.rjust(2, '0') }.join(' ')
          end

          def resource_position(model)
            if model.media? || model.generic?
              grade_position(model)
            else
              model.hierarchical_position
            end
          end

          # Overrides ElasticSearchDocument.search to include standards search
          def search(term, options = {})
            return repository.empty_response unless repository.index_exists?
            return repository.search(repository.all_query(options)) unless term.present?

            repository.multisearch(
              [
                repository.standards_query(term, options),
                repository.tags_query(term, [:tag_keywords], options),
                repository.tags_query(term, %i(tag_authors tag_texts), options),
                repository.fts_query(term, options)
              ]
            ).max_by(&:total)
          end

          private

          def attrs_from_page(model)
            {
              description: model.description,
              doc_type: 'page',
              grade: [],
              id: "page_#{model.slug}",
              model_type: :page,
              permalink: model.permalink,
              slug: model.slug,
              tag_keywords: model.keywords,
              teaser: model.teaser,
              title: model.title
            }
          end

          def attrs_from_resource(model)
            tags = model.named_tags

            {
              breadcrumbs: Lcms::Engine::Breadcrumbs.new(model).title,
              description: model.description,
              doc_type: doc_type(model),
              document_metadata: document_metadata(model),
              grade: model.grades.list,
              id: "resource_#{model.id}",
              model_id: model.id,
              model_type: 'resource',
              position: resource_position(model),
              slug: model.slug,
              subject: model.subject,
              tag_authors: tags[:authors] || [],
              tag_keywords: tags[:keywords] || [],
              tag_standards: tags[:ccss_standards] || [],
              tag_texts: tags[:texts] || [],
              teaser: model.teaser,
              title: model.title
            }
          end
        end

        def grades
          @grades ||= Lcms::Engine::Grades.new(self)
        end
      end
    end
  end
end
