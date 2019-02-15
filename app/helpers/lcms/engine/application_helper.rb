# frozen_string_literal: true

module Lcms
  module Engine
    # rubocop:disable Metrics/ModuleLength
    module ApplicationHelper
      ENABLE_BASE64_CACHING = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(
        ENV.fetch('ENABLE_BASE64_CACHING', true)
      )

      def add_class_for_path(link_path, klass, klass_prefix = nil)
        [
          klass_prefix,
          current_page?(link_path) ? klass : nil
        ].compact.join(' ')
      end

      def add_class_for_action(controller_name, action_name, klass, klass_prefix = nil)
        if controller.controller_name == controller_name.to_s && controller.action_name == action_name.to_s
          sufix = klass
        end
        "#{klass_prefix} #{sufix}"
      end

      def nav_link(link_text, link_path, attrs = {}, link_attrs = {})
        cls = add_class_for_path(link_path, 'active', attrs[:class])
        content_tag(:li, attrs.merge(class: cls)) { link_to link_text, link_path, link_attrs }
      end

      def flash_to_hash
        result = { message: nil, message_type: 'alert', status: false }
        flash.to_hash.slice('notice', 'alert').each do |name, message|
          result = { message: result[:message].present? ? "#{result.message}\n#{message}" : message,
                     message_type: name, status: true }
        end
        result
      end

      def header_mod
        controller.controller_name
      end

      def page_title
        page_content_for :page_title
      end

      def page_description
        page_content_for :description
      end

      def page_og_image
        if content_for?(:og_image)
          page_og_image = content_for(:og_image)
        else
          controller = controller_path.tr('/', '.')
          page_og_image = t("#{controller}.#{action_name}.og_image", default: t('default_og_image'))
        end
        page_og_image
      end

      # Render meta tag
      def redirect_meta_tag
        content_for(:redirect_meta_tag) if content_for?(:redirect_meta_tag)
      end

      # Use in views as redirection directive
      def redirect_via_meta_tag(to_url:, delay: 5)
        content_for(:redirect_meta_tag) do
          content_tag(:meta, nil, { content: "#{delay};url=#{to_url}", 'http-equiv' => 'refresh' }, true)
        end
      end

      def set_page_title(title) # rubocop:disable Naming/AccessorMethodName
        content_for :page_title do
          title
        end
      end

      def set_page_description(dsc) # rubocop:disable Naming/AccessorMethodName
        content_for :description do
          dsc
        end
      end

      def set_canonical_url(value) # rubocop:disable Naming/AccessorMethodName
        content_for(:canonical_url, value)
      end

      def base64_encoded_asset(path)
        AssetHelper.base64_encoded path, cache: ENABLE_BASE64_CACHING
      end

      def inlined_asset(path)
        AssetHelper.inlined path
      end

      def strip_tags_and_squish(str)
        return unless str.respond_to? :squish

        strip_tags(str).squish
      end

      def generic_page?
        controller.controller_name == 'resources' && controller.action_name == 'generic'
      end

      def set_social_media_sharing(target) # rubocop:disable Naming/AccessorMethodName
        @social_media_presenter = SocialMediaPresenter.new(target: target, view: self)
      end

      def social_media
        @social_media_presenter || SocialMediaPresenter.new(target: nil, view: self)
      end

      def color_code(model, base: false)
        subject_color_code = model.try(:subject) || 'default'
        grade_avg = base ? 'base' : model.grades.average
        "#{subject_color_code}-#{grade_avg}"
      end

      def selected_id?(id)
        selected_ids = params[:selected_ids]
        return unless selected_ids.present?

        case selected_ids
        when Array then selected_ids.include?(id.to_s)
        else selected_ids.split(',').include?(id.to_s)
        end
      end

      private

      def page_content_for(type)
        if content_for?(type)
          content = content_for(type)
        else
          controller = controller_path.tr('/', '.')
          type = type.to_s.gsub(/^page_/, '')
          content = t("#{controller}.#{action_name}.page_#{type}", default: t("default_#{type}"))
        end
        strip_tags_and_squish(content)
      end
    end
    # rubocop:enable Metrics/ModuleLength
  end
end
