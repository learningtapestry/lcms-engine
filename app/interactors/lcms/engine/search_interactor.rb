# frozen_string_literal: true

module Lcms
  module Engine
    class SearchInteractor < BaseInteractor
      attr_reader :props

      def run
        @props = pagination.serialize(documents, serializer).merge(filterbar.props)
      end

      private

      def filterbar
        @filterbar ||= Filterbar.new(params)
      end

      def pagination
        @pagination ||= Pagination.new(params)
      end

      def serializer
        SearchDocumentSerializer
      end

      def documents
        Search::Document
          .search(filterbar.search_term, filterbar.search_params)
          .paginate(pagination.params)
      end
    end
  end
end
