# frozen_string_literal: true

module Admin
  class CurriculumsController < AdminController
    def edit
      @curriculum = CurriculumPresenter.new
    end

    def update
      @form = CurriculumForm.new(params[:curriculum])
      if @form.save
        redirect_to admin_path, notice: t('.success')
      else
        @curriculum = CurriculumPresenter.new
        render :edit, alert: t('.error')
      end
    end
  end
end
