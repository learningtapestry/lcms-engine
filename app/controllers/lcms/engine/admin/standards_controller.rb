# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class StandardsController < AdminController
        include Lcms::Engine::Queryable

        before_action :find_standard, except: %i(import index)
        before_action :set_query_params # from Lcms::Engine::Queryable

        QUERY_ATTRS = %i(
          name
        ).freeze
        QUERY_ATTRS_NESTED = {}.freeze
        QUERY_ATTRS_KEYS = QUERY_ATTRS + QUERY_ATTRS_NESTED.keys

        def edit; end

        def import
          @standard_form = Lcms::Engine::StandardForm.new(standard_form_params)
          if @standard_form.save
            redirect_to lcms_engine.admin_standards_path, notice: t('.success')
          else
            @standards = Standard.order('id').paginate(page: 1)
            render :index
          end
        end

        def index
          @query = query_struct(@query_params)

          scope = Standard.order('id')
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

        def standard_form_params
          params.require(:standard_form).permit(:link)
        end

        def standard_params
          params.require(:standard).permit(:description)
        end
      end
    end
  end
end
