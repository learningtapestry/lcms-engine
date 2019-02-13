# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class BatchReimportsController < AdminController
        def new
          @query = OpenStruct.new(params[:query])
        end

        def create
          @query = OpenStruct.new params[:query].except(:type)
          entries = if materials?
                      AdminMaterialsQuery.call(@query)
                    else
                      AdminDocumentsQuery.call(@query)
                    end
          bulk_import entries
          render :import
        end

        private

        def bulk_import(docs)
          jobs = {}
          docs.each do |doc|
            job_id = job_class.perform_later(doc).job_id
            jobs[job_id] = { link: doc.file_url, status: 'waiting' }
          end
          @props = { jobs: jobs, type: params.dig(:query, :type), links: [] }
        end

        def job_class
          materials? ? MaterialParseJob : DocumentParseJob
        end

        def materials?
          params.dig(:query, :type) == 'materials'
        end
      end
    end
  end
end
