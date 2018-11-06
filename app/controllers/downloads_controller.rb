# frozen_string_literal: true

class DownloadsController < ApplicationController
  include AnalyticsTracking

  before_action :ga_track, except: %i(pdf_proxy preview)

  def show
    redirect_to attachment_url
  end

  def preview
    ga_track('preview')
    @resource = resource_download.resource
    RestClient.head(attachment_url)
  rescue RestClient::ExceptionWithResponse => e
    render text: e.response, status: '404'
  end

  def pdf_proxy
    uri = URI.parse attachment_url
    send_data uri.open.read,
              disposition: :inline,
              file_name: attachment_url.split('/').last,
              type: 'application/pdf'
  end

  private

  def attachment_url
    @attachment_url ||= download.attachment_url
  end

  def resource_download
    @resource_download ||= ResourceDownload.find(params[:id])
  end

  def download
    @download ||= resource_download.download
  end

  def ga_track(category = nil)
    action = show_with_slug_path(params[:slug]) if params[:slug].present?
    ga_track_download(action: action, label: attachment_url, category: category)
  end
end
