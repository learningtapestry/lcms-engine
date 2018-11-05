# frozen_string_literal: true

module Admin
  module ResourceHelper
    def attachment_content_type(download)
      t("content_type.#{download.content_type}") rescue download.content_type
    end

    def attachment_url(download)
      if download.url.present?
        download.url.sub('public://', 'http://k12-content.s3-website-us-east-1.amazonaws.com/')
      else
        download.file.url
      end
    end

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
