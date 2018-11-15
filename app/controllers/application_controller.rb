# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # require auth for acessing the pilot
  # before_action :pilot_authentication if Rails.env.production? || Rails.env.production_swap?

  before_action :authenticate_user!, unless: :pdf_request?

  before_action :check_user_has_survey_filled_in, if: :user_signed_in?, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :handle_x_frame_headers

  rescue_from ActiveRecord::RecordNotFound do
    render 'pages/not_found', status: :not_found
  end

  # engine helpers to generate PDF
  helper Openscied::Core::PdfHelper

  protected

  # Raise translation missing errors in controllers too
  def t(key, options = {})
    options[:raise] = true
    translate(key, options)
  end

  def check_user_has_survey_filled_in
    return if current_user.ready_to_go?

    store_location_for(:user, request.url) unless devise_controller?
    redirect_to survey_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:access_code])
  end

  def handle_x_frame_headers
    response.headers.delete('X-Frame-Options') if params[:controller].index('pdfjs_viewer').present?
  end

  def pdf_request?
    request.path.index('pdfjs').present? || request.path.index('pdf-proxy').present?
  end

  # NOTE: Temporary disabled
  # def pilot_authentication
  #   return unless request.format.html?
  #
  #   authenticate_or_request_with_http_basic('Administration') do |username, password|
  #     username == ENV['HTTP_AUTH_NAME'] && password == ENV['HTTP_AUTH_PASS']
  #   end
  # end
end
