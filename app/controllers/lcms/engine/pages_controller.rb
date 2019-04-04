# frozen_string_literal: true

module Lcms
  module Engine
    class PagesController < Lcms::Engine::ApplicationController
      def show
        @page = Lcms::Engine::Page.find(params[:id])
      end

      def show_slug
        slug = params[:slug].to_s
        @page = Lcms::Engine::Page.find_by(slug: slug)
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
  end
end
