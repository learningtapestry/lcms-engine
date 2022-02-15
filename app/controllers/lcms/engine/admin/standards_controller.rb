# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class StandardsController < AdminController
        before_action :find_standard, except: [:index]
        before_action :set_query_params

        def edit; end

        def index
          @query = OpenStruct.new @query_params # rubocop:disable Style/OpenStructUse

          scope = Standard.order(:id)
          scope = scope.search_by_name(@query.name) if @query.name.present?

          @standards = scope.paginate(page: params[:page])
        end

        def update
          if @standard.update(standard_params)
            redirect_to lcms_engine.admin_standards_path, notice: t('.success')
          else
            render :edit
          end
        end

        private

        def find_standard
          @standard = Standard.find(params[:id])
        end

        def set_query_params
          @query_params = params[:query]&.permit(:name) || {}
        end

        def standard_params
          params.require(:standard).permit(:description)
        end
      end
    end
  end
end
