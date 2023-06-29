# frozen_string_literal: true

module Lcms
  module Engine
    module ResourceHelper
      include Lcms::Engine::Engine.routes.url_helpers

      def show_resource_path(resource)
        if resource.slug.present?
          show_with_slug_path(resource.slug)
        else
          resource_path(resource)
        end
      end

      def type_name(resource)
        resource.curriculum_type&.capitalize
      end

      def copyrights_text(object)
        cc_descriptions = []
        object.copyrights.each do |copyright|
          cc_descriptions << copyright.value.strip if copyright.value.present?
        end
        object.copyrights.pluck(:disclaimer).uniq.each do |disclaimer|
          cc_descriptions << disclaimer.strip if disclaimer.present?
        end
        cc_descriptions.join(' ')
      end

      def resource_breadcrumbs_with_links(resource)
        breadcrumbs = Breadcrumbs.new(resource)
        pieces = breadcrumbs.full_title.split(' / ')
        short_pieces = breadcrumbs.short_title.split(' / ')

        [].tap do |result|
          pieces.each_with_index do |piece, idx|
            ((result << piece) && next) if idx.zero?

            slug = Slug.build_from(pieces[0..idx])

            link = link_to show_with_slug_path(slug) do
              show = content_tag(:span, piece, class: 'show-for-ipad')
              short_piece = idx == pieces.size - 1 ? piece : short_pieces[idx]
              hide = content_tag(:span, short_piece, class: 'hide-for-ipad')
              "#{show} #{hide}".html_safe
            end

            result << link
          end
        end.join(' / ').html_safe
      end

      def prerequisites_standards(resource)
        ids = StandardLink
                .where(standard_end_id: resource.standards.pluck(:id))
                .where.not(link_type: 'c')
                .pluck(:standard_begin_id)
        Standard
          .where(id: ids).pluck(:alt_names).flatten.uniq
          .map { |n| Standard.filter_ccss_standards(n, resource.subject) }.compact.sort
      end
    end
  end
end
