# frozen_string_literal: true

module Admin
  class AccessCodesController < AdminController
    before_action :set_resource, except: %i(index new create)

    def create
      @access_code = AccessCode.new(permitted_params)
      if @access_code.save
        redirect_to({ action: :index }, notice: t('.success'))
      else
        render :new
      end
    end

    def destroy
      @access_code.destroy
      redirect_to({ action: :index }, notice: t('.success'))
    end

    def index
      @access_codes = AccessCode.order(code: :asc).paginate(page: params[:page])
    end

    def new
      @access_code = AccessCode.new
    end

    def update
      if @access_code.update(permitted_params)
        redirect_to({ action: :index }, notice: t('.success'))
      else
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
