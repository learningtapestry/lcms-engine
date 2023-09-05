# frozen_string_literal: true

module Lcms
  module Engine
    module ViewHelper
      ENABLE_BASE64_CACHING = ActiveRecord::Type::Boolean.new.cast ENV.fetch('ENABLE_BASE64_CACHING', true)

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

      def page_title
        page_content_for :page_title
      end

      def set_page_title(title) # rubocop:disable Naming/AccessorMethodName
        content_for :page_title do
          title
        end
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

      def color_code(model, base: false)
        subject_color_code = model.try(:subject) || 'default'
        grade_avg = base ? 'base' : model.grades.average
        "#{subject_color_code}-#{grade_avg}"
      end

      def selected_id?(id)
        selected_ids = params[:selected_ids]
        return false unless selected_ids.present?

        case selected_ids
        when Array
          selected_ids.include?(id.to_s)
        else
          selected_ids.split(',').include?(id.to_s)
        end
      end

      def lcms_engine_url_helpers
        @lcms_engine_url_helpers ||= Lcms::Engine::Engine.routes.url_helpers
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
  end
end
