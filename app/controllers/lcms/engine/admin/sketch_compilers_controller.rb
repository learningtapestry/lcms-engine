# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class SketchCompilersController < AdminController
        include GoogleCredentials

        layout 'admin'

        before_action :validate_params, only: [:compile]

        def compile
          response = SketchCompiler
                       .new(current_user.id, request.remote_ip, params[:version])
                       .compile(params[:url], params[:foundational_url])

          if response.success?
            url = DocumentExporter::Gdoc::Base.url_for JSON.parse(response.body)['id']
            redirect_to :back, notice: t('.success', url: url)
          else
            redirect_to :back, alert: t('.compile_error')
          end
        end

        def new
          head :bad_request unless google_credentials.present?
          @version = params[:version].presence || 'v1'
        end

        private

        def validate_params
          redirect_to new_admin_sketch_compiler_path, alert: t('.error') unless params[:url].present?
        end
      end
    end
  end
end
