# frozen_string_literal: true

module Admin
  class StandardsController < AdminController
    before_action :find_standard, except: [:index]

    def edit; end

    def index
      @query = OpenStruct.new params[:query]

      scope = Standard.order(:id)
      scope = scope.search_by_name(@query.name) if @query.name.present?

      @standards = scope.paginate(page: params[:page])
    end

    def update
      if @standard.update(standard_params)
        redirect_to admin_standards_path, notice: t('.success')
      else
        render :edit
      end
    end

    private

    def find_standard
      @standard = Standard.find(params[:id])
    end

    def standard_params
      params.require(:standard).permit(:description)
    end
  end
end
