# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class AccessCodesController < AdminController
        before_action :set_resource, except: %i(index new create)

        def create
          @access_code = AccessCode.new(permitted_params)
          if @access_code.save
            redirect_to lcms_engine.admin_access_codes_path, notice: t('.success')
          else
            render :new
          end
        end

        def destroy
          @access_code.destroy
          redirect_to lcms_engine.admin_access_codes_path, notice: t('.success')
        end

        def edit
          @url = lcms_engine.admin_access_code_path(@access_code)
        end

        def index
          @access_codes = AccessCode.order(code: :asc).paginate(page: params[:page])
        end

        def new
          @access_code = AccessCode.new
        end

        def update
          if @access_code.update(permitted_params)
            redirect_to lcms_engine.admin_access_codes_path, notice: t('.success')
          else
            @url = lcms_engine.admin_access_code_path(@access_code)
            render :edit
          end
        end

        private

        def permitted_params
          params.require(:access_code).permit(:active, :code)
        end

        def set_resource
          @access_code = AccessCode.find(params[:id])
        end
      end
    end
  end
end
