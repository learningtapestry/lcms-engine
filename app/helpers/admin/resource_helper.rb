# frozen_string_literal: true

module Admin
  module ResourceHelper
    def language_collection_options
      Language.order(:name).map { |lang| [lang.name, lang.id] }
    end

    def resource_status(resource)
      status = resource.hidden? ? :hidden : :active
      t(status, scope: :resource_statuses)
    end

    def related_resource_type(resource)
      resource_types = resource.resource_types.pluck(:name)

      if resource_types.include?('video')
        t('resource_types.video')
      else
        t('resource_types.resource')
      end
    end
  end
end
