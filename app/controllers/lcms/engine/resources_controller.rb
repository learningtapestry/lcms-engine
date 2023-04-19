# frozen_string_literal: true

module Lcms
  module Engine
    class ResourcesController < Lcms::Engine::ApplicationController
      def show
        @resource = find_resource

        # redirect to document if resource has it (#161)
        return redirect_to dynamic_document_path(@resource.document) if @resource.document?

        # redirect to the path with slug if we are using just the id
        redirect_to lcms_engine.show_with_slug_path(@resource.slug), status: 301 if using_id?
      end

      def media
        resource = Resource.find(params[:id])
        return redirect_to lcms_engine.resource_path(resource) unless resource.media?

        @resource = MediaPresenter.new(resource)
      end

      def generic
        resource = Resource.find(params[:id])
        return redirect_to lcms_engine.resource_path(resource) unless resource.generic?

        @resource = GenericPresenter.new(resource)
      end

      def pdf_proxy
        return head(:not_found) if (url = params[:url]).blank?

        uri = URI.parse(url)
        send_data uri.open.read, disposition: :inline, file_name: url.split('/').last
      rescue StandardError => e
        Rails.logger.warn "PDF-proxy failed! Url: #{url}, Error: #{e.message}"
        head :bad_request
      end

      protected

      def find_resource
        res = if params[:slug].present?
                Resource.find_by! slug: params[:slug]
              else
                Resource.find params[:id]
              end
        ResourcePresenter.new(res)
      end

      def grade_or_module?
        @resource.grade? || @resource.module?
      end

      def using_id?
        params[:id].present? && @resource.slug
      end
    end
  end
end
