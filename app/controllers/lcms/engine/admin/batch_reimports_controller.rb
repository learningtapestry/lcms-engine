# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class BatchReimportsController < AdminController
        include Reimportable
        include Lcms::Engine::Queryable

        before_action :set_query_params

        QUERY_ATTRS = %i(
          grade
          module
          subject
          type
          unit
        ).freeze
        QUERY_ATTRS_NESTED = {}.freeze
        QUERY_ATTRS_KEYS = QUERY_ATTRS + QUERY_ATTRS_NESTED.keys

        def new
          @query = query_struct(@query_params)
        end

        def create
          @query = query_struct(@query_params.except(:type))

          # @see lcms.yml
          # Possible default values:
          #  - ::Lcms::Engine::AdminDocumentsQuery
          #  - ::Lcms::Engine::AdminMaterialsQuery
          entries = if materials?
                      DocTemplate.config.dig('queries', 'material').constantize.call(@query)
                    else
                      DocTemplate.config.dig('queries', 'document').constantize.call(@query)
                    end

          if entries.empty?
            redirect_to lcms_engine.new_admin_batch_reimport_path(query: @query.to_h),
                        notice: 'Nothing found'
            return
          end

          bulk_import entries.map(&:file_url)
          render :import
        end

        def import_status
          data = import_status_for(job_class)
          render json: data, status: :ok
        end

        private

        #
        # @param [Array<String>] file_urls
        #
        def bulk_import(file_urls)
          jobs = file_urls.each_with_object({}) do |url, jobs_|
            job_id = job_class.perform_later(url).job_id
            jobs_[job_id] = { link: url, status: 'waiting' }
          end
          @props = {
            jobs:,
            links: view_links,
            polling_path: lcms_engine.import_status_admin_batch_reimport_path,
            type: params.dig(:query, :type)
          }.transform_keys! { _1.to_s.camelize(:lower) }
        end

        def job_class
          materials? ? DocumentGenerator.material_parse_job : DocumentGenerator.document_parse_job
        end

        def materials?
          params.dig(:query, :type) == 'materials' || params[:type].to_s == 'materials'
        end

        #
        # @return [Array<String>]
        #
        def view_links
          type = materials? ? :materials : :documents
          Array.wrap(AdminController.settings.dig(type, :view_links))
        end

        def set_query_params
          super
          @query_params[:grade] = adjust_grade_value(@query_params[:grade])
        end

        def adjust_grade_value(val)
          number_val = val.to_s[/\d+/]
          number_val.nil? ? val : number_val
        end
      end
    end
  end
end
