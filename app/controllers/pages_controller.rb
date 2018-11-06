# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end

  def show_slug
    slug = params[:slug].to_s
    @page = Page.find_by(slug: slug)
    render slug if template_exists?(slug, 'pages')
  end

  # NOTE: Temporary disabled
  # def leadership
  #   @leadership_posts = LeadershipPost.all.order_by_name_with_precedence
  # end

  def not_found
    render status: :not_found
  end
end
