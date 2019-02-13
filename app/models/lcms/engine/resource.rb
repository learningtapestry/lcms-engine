# frozen_string_literal: true

module Lcms
  module Engine
    class Resource < ActiveRecord::Base
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

      SUBJECTS = %w(ela math lead).freeze
      HIERARCHY = %i(subject grade module unit lesson).freeze

      include Searchable
      include Navigable

      mount_uploader :image_file, ResourceImageUploader

      acts_as_taggable_on :content_sources, :download_types, :resource_types, :tags, :topics
      has_closure_tree order: :level_position, dependent: :destroy

      belongs_to :parent, class_name: 'Resource', foreign_key: 'parent_id'

      belongs_to :author
      belongs_to :curriculum

      # Additional resources
      has_many :resource_additional_resources, dependent: :destroy
      has_many :additional_resources, through: :resource_additional_resources

      has_many :resource_standards, dependent: :destroy
      has_many :standards, through: :resource_standards

      # Downloads.
      has_many :resource_downloads, dependent: :destroy
      has_many :downloads, through: :resource_downloads
      accepts_nested_attributes_for :resource_downloads, allow_destroy: true

      # Reading assignments.
      has_many :resource_reading_assignments, dependent: :destroy
      alias_attribute :reading_assignments, :resource_reading_assignments
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
      validates :url, presence: true, url: true, if: %i(video? podcast?)

      scope :where_grade, ->(grades) { where_metadata_in :grade, grades }
      scope :where_module, ->(modules) { where_metadata_in :module, modules }
      scope :where_subject, ->(subjects) { where_metadata_in :subject, subjects }
      scope :media, -> { where(resource_type: MEDIA_TYPES) }
      scope :generic_resources, -> { where(resource_type: GENERIC_TYPES) }
      scope :ordered, -> { order(:hierarchical_position, :slug) }

      before_save :update_metadata, :update_slug, :update_position

      after_save :update_descendants_meta, :update_descendants_position,
                 :update_descendants_tree, :update_descendants_author

      before_destroy :destroy_additional_resources

      class << self
        # Define dynamic scopes for hierarchy levels.
        # I,e: `grades`, `units`, etc
        HIERARCHY.map(&:to_s).each do |level|
          define_method(:"#{level.pluralize}") { where(curriculum_type: level) }
        end

        def metadata_from_dir(dir)
          pairs = HIERARCHY[0...dir.size].zip(dir)
          Hash[pairs].compact.stringify_keys
        end

        def find_by_directory(*dir)
          dir = dir&.flatten&.select(&:present?)
          return unless dir.present?

          type = HIERARCHY[dir.size - 1]
          meta = metadata_from_dir(dir).to_json
          where('metadata @> ?', meta).where(curriculum_type: type).first
        end

        def find_podcast_by_url(url)
          podcast.where(url: url).first
        end

        def find_video_by_url(url)
          video_id = MediaEmbed.video_id(url)
          video.where("url ~ '#{video_id}(&|$)'").first
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
          elsif (default = Curriculum.default)
            where(curriculum_id: default.id)
          else
            where(nil)
          end
        end

        def where_metadata_in(key, arr)
          arr = Array.wrap arr
          clauses = Array.new(arr.count) { "metadata->>'#{key}' = ?" }.join(' OR ')
          where(clauses, *arr)
        end
      end

      # Define predicate methods for subjects.
      # I,e: #ela?, #math?, ..
      SUBJECTS.each do |subject_name|
        define_method(:"#{subject_name}?") { subject == subject_name.to_s }
      end

      # Define predicate methods for hierarchy levels.
      # I,e: #subject?, #grade?, #lesson?, ...
      HIERARCHY.each do |level|
        define_method(:"#{level}?") { curriculum_type.present? && curriculum_type.casecmp(level.to_s).zero? }
      end

      def tree?
        curriculum_id.present?
      end

      def assessment?
        metadata['assessment'].present?
      end

      def media?
        %w(video podcast).include? resource_type
      end

      def generic?
        %w(text_set quick_reference_guide resource_other).include?(resource_type)
      end

      # `Optional prerequisite` - https://github.com/learningtapestry/unbounded/issues/557
      def opr?
        tag_list.include?('opr')
      end

      def prerequisite?
        tag_list.include?('prereq')
      end

      def directory
        @directory ||= HIERARCHY.map do |key|
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
        @lesson_number ||= short_title.match(/(\d+)/)&.[](1).to_i
      end

      def related_resources
        @related_resources ||= resource_related_resources
                                 .includes(:related_resource)
                                 .order(:position)
                                 .map(&:related_resource)
      end

      def download_categories
        @download_categories ||=
          resource_downloads.includes(:download_category).includes(:download)
            .sort_by { |rd| rd.download_category&.position.to_i }
            .group_by { |d| d.download_category&.title.to_s }
            .transform_values { |v| v.sort_by { |d| [d.download.main ? 0 : 1, d.download.title] } }
      end

      def pdf_downloads?(category = nil)
        if category.present?
          resource_downloads.joins(:download)
            .where(download_category: category)
            .where(downloads: { content_type: 'application/pdf' })
            .exists?
        else
          downloads.where(content_type: 'application/pdf').exists?
        end
      end

      alias do_not_skip_indexing? should_index?
      def should_index?
        do_not_skip_indexing? && (tree? || media? || generic?)
      end

      def named_tags
        {
          keywords: (tag_list + topic_list).compact.uniq,
          resource_type: resource_type,
          ell_appropriate: ell_appropriate,
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

      def next_hierarchy_level
        index = HIERARCHY.index(curriculum_type.to_sym)
        HIERARCHY[index + 1]
      end

      def unit_bundles?
        unit? && document_bundles.any?
      end

      def add_grade_author(author)
        grade = grade? ? self : ancestors.detect(&:grade?)
        raise 'Grade not found for this resource' unless grade

        grade.author_id = author.is_a?(Integer) ? author : author.id
        grade.save
      end

      def self_and_ancestors_not_persisted
        # during create we can't call self_and_ancestors directly on the resource
        # because this query uses the associations on resources_hierarchies
        # which are only created after the resource is persisted
        [self] + parent&.self_and_ancestors.to_a
      end

      def update_metadata
        meta = self_and_ancestors_not_persisted
                 .each_with_object({}) do |r, obj|
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

        descendants.update_all author_id: author_id
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
