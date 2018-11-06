# frozen_string_literal: true

module Admin
  class ResourceBulkEditsController < AdminController
    before_action :load_resources

    def new
      if @resources.any?
        @resource = BulkEditResourcesService.new(@resources).init_sample
      else
        redirect_to :admin_resources, alert: t('.no_resources')
      end
    end

    def create
      BulkEditResourcesService.new(@resources, resource_params).edit!
      resources_count_msg = t(:resources_count, count: @resources.count)
      redirect_to :admin_resources, notice: t('.success', count: @resources.count, resources_count: resources_count_msg)
    end

    private

    def load_resources
      @resources = Resource.where(id: params[:ids]).includes(:standards)
    end

    def resource_params
      params.require(:resource)
        .permit(standard_ids: [],
                grades: [],
                resource_type_list: [],
                tag_list: [])
    end
  end
end
