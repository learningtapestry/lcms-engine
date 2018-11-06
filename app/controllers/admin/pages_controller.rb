# frozen_string_literal: true

module Admin
  class PagesController < AdminController
    before_action :find_resource, except: %i(index new create)

    def index
      @pages = Page.order(id: :desc)
    end

    def new
      @page = Page.new
    end

    def create
      @page = Page.new(page_params)

      if @page.save
        redirect_to page_url(@page), notice: t('.success')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @page.update_attributes(page_params)
        redirect_to page_url(@page), notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      @page.destroy
      redirect_to :admin_pages, notice: t('.success')
    end

    private

    def find_resource
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:body, :title, :slug)
    end
  end
end
