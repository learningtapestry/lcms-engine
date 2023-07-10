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
