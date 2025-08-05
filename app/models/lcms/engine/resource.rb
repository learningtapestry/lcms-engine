# frozen_string_literal: true

module Lcms
  module Engine
    class Resource < ApplicationRecord
      include Filterable

      enum resource_type: {
        resource: 1,
        podcast: 2,
        video: 3,
        quick_reference_guide: 4,
        text_set: 5,
        resource_other: 6
      }

      MEDIA_TYPES = %i(video podcast).map { |t| resource_types[t] }.freeze
      GENERIC_TYPES = %i(text_set quick_reference_guide resource_other).map { |t| resource_types[t] }.freeze

      SUBJECTS = %w(ela math).freeze
      HIERARCHY = %i(subject grade module unit lesson).freeze

      mount_uploader :image_file, ResourceImageUploader

      acts_as_taggable_on :resource_types, :tags
      has_closure_tree order: :level_position, dependent: :destroy, numeric_order: true

      belongs_to :parent, class_name: 'Lcms::Engine::Resource', foreign_key: 'parent_id', optional: true

      belongs_to :author, optional: true
      belongs_to :curriculum, optional: true

      # Additional resources
      has_many :resource_additional_resources, dependent: :destroy
      has_many :additional_resources, through: :resource_additional_resources

      has_many :resource_standards, dependent: :destroy
      has_many :standards, through: :resource_standards

      # Reading assignments.
      has_many :resource_reading_assignments, dependent: :destroy
      alias reading_assignments resource_reading_assignments
      has_many :reading_assignment_texts, through: :resource_reading_assignments

      # Related resources.
      has_many :resource_related_resources, dependent: :destroy
      has_many :related_resources, through: :resource_related_resources, class_name: 'Resource'
      has_many :resource_related_resources_as_related,
               class_name: 'ResourceRelatedResource',
               foreign_key: 'related_resource_id',
               dependent: :destroy

      has_many :copyright_attributions, dependent: :destroy
      has_many :social_thumbnails, as: :target
      has_many :documents, dependent: :destroy

      has_many :document_bundles, dependent: :destroy

      validates :title, presence: true
      validates :url, presence: true, url: true, if: -> { video? || podcast? }

      scope :media, -> { where(resource_type: MEDIA_TYPES) }
      scope :generic_resources, -> { where(resource_type: GENERIC_TYPES) }
      scope :ordered, -> { order(:hierarchical_position, :slug) }

      # @param link_path [String] when nested, use a dot to separate the levels, eg "level1.level2"
      # @param datetime [DateTime, Time]
      scope :where_link_updated_after, lambda { |link_path, datetime|
        path_elements = link_path.split('.')
        jsonb_path = path_elements.map(&:to_s).join(',')

        # Convert datetime to Unix timestamp for comparison
        timestamp = datetime.to_i

        where("(links #>> '{#{jsonb_path},timestamp}')::bigint >= ?", timestamp)
      }

      before_save :update_metadata, :update_slug, :update_position

      after_save :update_descendants_meta, :update_descendants_position,
                 :update_descendants_tree, :update_descendants_author

      before_destroy :destroy_additional_resources

      class << self
        def metadata_from_dir(dir)
          pairs = hierarchy[0...dir.size].zip(dir)
          pairs.to_h.compact.stringify_keys
        end

        def find_by_directory(*dir)
          dir = dir.flatten.select(&:present?)
          return unless dir.present?

          type = hierarchy[dir.size - 1]
          meta = metadata_from_dir(dir).to_json
          where('metadata @> ?', meta).where(curriculum_type: type).first
        end

        def hierarchy
          Lcms::Engine::Resource::HIERARCHY
        end

        # used for ransack search on the admin
        def ransackable_scopes(_auth_object = nil)
          %i(grades)
        end

        # return resources tree by a curriculum name
        # if no argument is provided, then it's any curriculum tree.
        def tree(name = nil)
          if name.present?
            joins(:curriculum).where('curriculums.name = ? OR curriculums.slug = ?', name, name)
          else
            where(curriculum_id: Lcms::Engine::Curriculum.default&.id)
          end
        end
      end

      # Define predicate methods for subjects.
      # I,e: #ela?, #math?, ..
      SUBJECTS.each do |subject_name|
        define_method(:"#{subject_name}?") do
          # @type self: Lcms::Engine::Resource
          subject == subject_name.to_s
        end
      end

      # Define predicate methods for hierarchy levels.
      # Sample: #subject?, #grade?, #lesson?, ...
      HIERARCHY.each do |level|
        define_method(:"#{level}?") do
          # @type self: Lcms::Engine::Resource
          curriculum_type.present? && curriculum_type.to_s.casecmp(level.to_s).to_i.zero?
        end

        # Define dynamic scopes for hierarchy levels.
        # I.e., `grades`, `units`, etc.
        define_singleton_method(level.to_s.pluralize) do
          where(curriculum_type: level)
        end
      end

      def tree?
        curriculum_id.present?
      end

      def assessment?
        metadata['assessment'].present?
      end

      def media?
        %w(video podcast).include?(resource_type.to_s)
      end

      def generic?
        %w(text_set quick_reference_guide resource_other).include?(resource_type.to_s)
      end

      def directory
        @directory ||= Lcms::Engine::Resource.hierarchy.map do |key|
          key == :grade ? grades.average(abbr: false) : metadata[key.to_s]
        end.compact
      end

      def subject
        metadata['subject']
      end

      def grades
        Grades.new(self)
      end

      def grades=(gds)
        metadata.merge! 'grade' => gds
      end

      def lesson_number
        @lesson_number ||= short_title.to_s.match(/(\d+)/)&.[](1).to_i
      end

      def related_resources
        @related_resources ||= resource_related_resources
                                 .includes(:related_resource)
                                 .order(:position)
                                 .map(&:related_resource)
      end

      def named_tags
        {
          keywords: tag_list.compact.uniq,
          resource_type:,
          ell_appropriate:,
          ccss_standards: tag_standards,
          ccss_domain: nil, # resource.standards.map { |std| std.domain.try(:name) }.uniq
          ccss_cluster: nil, #  resource.standards.map { |std| std.cluster.try(:name) }.uniq
          authors: reading_assignment_texts.map { |t| t.author.try(:name) }.compact.uniq,
          texts: reading_assignment_texts.map(&:name).uniq
        }
      end

      def filtered_named_tags
        filtered_named_tags = named_tags
        stds = named_tags[:ccss_standards].map { |n| Standard.filter_ccss_standards(n, subject) }.compact
        filtered_named_tags.merge(ccss_standards: stds)
      end

      def tag_standards
        standards.map(&:alt_names).flatten.uniq
      end

      def copyrights
        copyright_attributions
      end

      def document
        documents.actives.order(updated_at: :desc).first
      end

      def document?
        document.present?
      end

      def next
        @next ||=
          if level_position.nil?
            nil
          elsif level_position.to_i < siblings.size
            siblings.where(level_position: level_position.to_i + 1).first
          else
            # first element of next node from parent level
            parent&.next&.children&.first
          end
      end

      def next_hierarchy_level
        index = Lcms::Engine::Resource.hierarchy.index(curriculum_type.to_s.to_sym)
        Lcms::Engine::Resource.hierarchy[index + 1]
      end

      def parents
        ancestors.reverse
      end

      def previous
        @previous ||=
          if level_position.to_i.positive?
            siblings.where(level_position: level_position.to_i - 1).first
          else
            # last element of previous node from parent level
            parent&.previous&.children&.last
          end
      end

      def unit_bundles?
        unit? && document_bundles.any?
      end

      def self_and_ancestors_not_persisted
        # during create we can't call self_and_ancestors directly on the resource
        # because this query uses the associations on resources_hierarchies
        # which are only created after the resource is persisted
        [self] + parent&.self_and_ancestors.to_a
      end

      def update_metadata
        meta = self_and_ancestors_not_persisted
                 .each_with_object({}) do |r, obj| # steep:ignore
          obj[r.curriculum_type] = r.short_title
        end.compact
        metadata.merge! meta if meta.present?
      end

      def update_position
        self.hierarchical_position = HierarchicalPosition.new(self).position
      end

      private

      def destroy_additional_resources
        ResourceAdditionalResource.where(additional_resource_id: id).destroy_all
      end

      def update_descendants_author
        # update only if a grade author has changed
        return unless grade? && author_id_changed?

        descendants.update_all author_id:
      end

      def update_descendants_meta
        # update only if is not a lesson (no descendants) and short_title has changed
        return unless !lesson? && short_title_changed?

        descendants.each do |r|
          r.metadata[curriculum_type] = short_title
          r.save
        end
      end

      def update_descendants_position
        # update only if is not a lesson (no descendants) and level_position has changed
        return unless !lesson? && level_position_changed?

        descendants.each { |r| r.update_position && r.save }
      end

      def update_descendants_tree
        # update only if is not a lesson (no descendants) and `tree` has changed to false
        return unless !lesson? && curriculum_id_changed? && !tree?

        descendants.each { |r| r.update curriculum_id: nil }
      end

      def update_slug
        self.slug = Slug.new(self).value
      end
    end
  end
end
