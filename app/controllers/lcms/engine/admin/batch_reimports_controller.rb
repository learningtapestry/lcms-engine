# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class BatchReimportsController < AdminController
        def new
          @query = OpenStruct.new(params[:query]) # rubocop:disable Style/OpenStructUse
        end

        def create
          @query = OpenStruct.new params[:query].except(:type) # rubocop:disable Style/OpenStructUse

          # @see lcms.yml
          # Possible default values:
          #  - ::Lcms::Engine::AdminDocumentsQuery
          #  - ::Lcms::Engine::AdminMaterialsQuery
          entries = if materials?
                      DocTemplate.config.dig('queries', 'material').constantize.call(@query)
                    else
                      DocTemplate.config('queries', 'document').constantize.call(@query)
                    end

          bulk_import entries.map(&:file_url)
          render :import
        end

        private

        #
        # @param [Array<String>] file_urls
        #
        def bulk_import(file_urls)
          jobs = {}
          file_urls.each do |url|
            job_id = job_class.perform_later(url).job_id
            jobs[job_id] = { link: url, status: 'waiting' }
          end
          @props = { jobs:, type: params.dig(:query, :type), links: view_links }
        end

        def job_class
          materials? ? DocumentGenerator.material_parse_job : DocumentGenerator.document_parse_job
        end

        def materials?
          params.dig(:query, :type) == 'materials'
        end
      end
    end
  end
end
