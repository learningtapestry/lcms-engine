# frozen_string_literal: true

class GenericPresenter < ResourcePresenter
  def generic_title
    "#{subject.try(:upcase)} #{grades.to_str}"
  end

  def type_name
    I18n.t("resource_types.#{resource_type}")
  end

  def preview?
    downloads.any? { |d| d.main? && d.attachment_content_type == 'pdf' && RestClient.head(d.attachment_url) }
  rescue RestClient::ExceptionWithResponse
    false
  end

  def pdf_preview_download
    resource_downloads.find { |d| d.download.main? && d.download.attachment_content_type == 'pdf' }
  end
end
