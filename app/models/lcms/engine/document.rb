# frozen_string_literal: true

module Lcms
  module Engine
    class Document < ApplicationRecord
      include Filterable
      include Partable

      GOOGLE_URL_PREFIX = 'https://docs.google.com/document/d'

      belongs_to :resource, optional: true
      has_many :document_parts, as: :renderer, dependent: :delete_all
      has_and_belongs_to_many :materials

      after_destroy :destroy_connected_resource

      before_save :clean_curriculum_metadata
      before_save :set_resource_from_metadata

      serialize :toc, coder: DocTemplate::Objects::TocMetadata

      scope :actives,   -> { where(active: true) }
      scope :inactives, -> { where(active: false) }

      scope :failed, -> { where(reimported: false) }

      scope :where_metadata, ->(key, val) { where('documents.metadata ->> ? = ?', key, val.to_s) }

      scope :order_by_curriculum, lambda {
        select('documents.*, resources.hierarchical_position')
          .joins(:resource)
          .order('resources.hierarchical_position ASC')
      }

      scope :filter_by_term, lambda { |search_term|
        term = "%#{search_term}%"
        joins(:resource).where('resources.title ILIKE ? OR documents.name ILIKE ?', term, term)
      }

      scope :filter_by_subject, ->(subject) { where_metadata(:subject, subject) }
      scope :filter_by_grade, ->(grade) { where_metadata(:grade, grade) }

      scope :filter_by_unit, lambda { |u|
        where("(lower(documents.metadata ->> 'unit') = :u OR lower(documents.metadata ->> 'topic') = :u)",
              u: u.to_s.downcase)
      }

      scope :filter_by_module, lambda { |mod|
        sql = <<-SQL
      (documents.metadata ->> 'subject' <> 'ela' AND documents.metadata ->> 'unit' = :mod)
        OR (documents.metadata ->> 'subject' = 'ela' AND documents.metadata ->> 'module' = :mod)
        SQL
        where(sql, mod:)
      }

      scope :with_broken_materials, lambda {
        joins("LEFT JOIN jsonb_each(documents.links->'materials') AS links ON TRUE")
          .joins('LEFT JOIN materials as m on m.id = links.key::integer')
          .where('((links.value -> ?)::text IS NULL) OR ((links.value -> ?)::text IS NULL)', 'gdoc', 'url')
          .where.not("m.metadata ->> 'type' = ?", 'pdf')
          .distinct
      }

      scope :with_updated_materials, lambda {
        joins(:materials).where('materials.updated_at > documents.updated_at')
      }

      def activate!
        self.class.transaction do
          # de-active all other lessons for this resource
          self.class.where(resource_id:).where.not(id:).update_all(active: false)
          # activate this lesson. PS: use a simple sql update, no callbacks
          update_columns(active: true)
        end
      end

      def assessment?
        resource&.assessment?
      end

      def ela?
        metadata['subject'].to_s.casecmp('ela').zero?
      end

      def file_url
        return unless file_id.present?

        "#{GOOGLE_URL_PREFIX}/#{file_id}"
      end

      def gdoc_material_ids
        materials.gdoc.pluck(:id)
      end

      def materials_anchors
        {}.tap do |materials_with_anchors| # steep:ignore
          toc.collect_children.each do |x|
            x.material_ids.each do |m|
              materials_with_anchors[m] ||= { optional: [], anchors: [] } # steep:ignore
              materials_with_anchors[m][x.optional ? :optional : :anchors] << x.anchor
            end
          end
        end
      end

      def math?
        metadata['subject'].to_s.casecmp('math').zero?
      end

      def ordered_material_ids
        toc.ordered_material_ids
      end

      def tmp_link(key)
        url = links[key]
        with_lock do
          reload.links.delete(key)
          update links:
        end
        url
      end

      private

      def clean_curriculum_metadata
        return unless metadata.present?

        # downcase subjects
        metadata['subject'] = metadata['subject']&.downcase

        # store only the lesson number
        # or alphanumeric - needed by OPR type, see https://github.com/learningtapestry/unbounded/issues/557
        lesson = metadata['lesson']
        metadata['lesson'] = lesson.match(/lesson (\w+)/i).try(:[], 1) || lesson if lesson.present?
      end

      def destroy_connected_resource
        resource&.destroy if active?
      end

      def set_resource_from_metadata
        return unless metadata.present?

        context = DocTemplate.config.dig('metadata', 'context').constantize
        resource = context.new(metadata).find_or_create_resource

        self.resource_id = resource.id
      end
    end
  end
end
