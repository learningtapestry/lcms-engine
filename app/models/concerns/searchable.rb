# frozen_string_literal: true

require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_indexing

    after_commit :index_document,  on: %i(create update), if: :should_index?
    after_commit :delete_document, on: :destroy, if: :should_index?

    def self.search(term, options = {})
      search_model.search term, options.merge!(model_type: name.underscore)
    end

    private

    def self.search_model
      @search_model ||= Search::Document
    end

    def delete_document
      search_repo.delete search_doc
    rescue Faraday::ConnectionFailed, Elasticsearch::Transport::Transport::Errors::NotFound => e
      Rails.logger.warn("index_document failed: #{e.message}")
    end

    def search_doc
      self.class.search_model.build_from self
    end

    def index_document
      doc = search_doc
      search_repo.save(doc) if doc.present?
    rescue Faraday::ConnectionFailed => e
      Rails.logger.warn("index_document failed: #{e.message}")
    end

    def search_repo
      @search_repo ||= Search::Repository.new
    end

    def should_index?
      !skip_indexing && search_repo.index_exists?
    end
  end
end
