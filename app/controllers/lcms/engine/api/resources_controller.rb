# frozen_string_literal: true

module Lcms
  module Engine
    module Api
      class ResourcesController < BaseController
        def index
          resources = Resource

          # format for the query string is: ?link_updated_after={link_path}:{timestamp}
          if params[:link_updated_after]
            link_path, timestamp = params[:link_updated_after].split(':')

            resources = resources.where_link_updated_after(link_path, Time.at(timestamp.to_i))
          end

          resources = resources.where(resource_type: params[:resource_type]) if params[:resource_type]

          render json: resources.all.as_json
        end
      end
    end
  end
end
