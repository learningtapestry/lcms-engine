# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class MaterialsController < AdminController
        include Lcms::Engine::GoogleCredentials
        include Lcms::Engine::PathHelper
        include Reimportable

        before_action :find_selected, only: %i(destroy_selected reimport_selected)
        before_action :set_query_params

        def index
          @query = OpenStruct.new @query_params # rubocop:disable Style/OpenStructUse
          @materials = DocTemplate.config['queries']['material'].constantize.call(@query, page: params[:page])
          render_customized_view
        end

        def create
          @material_form = DocumentGenerator.material_form.new(form_params.except(:async))

          return create_multiple if form_params[:link].match?(RE_GOOGLE_FOLDER)

          form_params[:async].to_i.zero? ? create_sync : create_async
        end

        def destroy
          material = Material.find(params[:id])
          material.destroy
          redirect_to lcms_engine.admin_materials_path(query: @query_params), notice: t('.success')
        end

        def destroy_selected
          count = @materials.destroy_all.count
          redirect_to lcms_engine.admin_materials_path(query: @query_params), notice: t('.success', count: count)
        end

        def import_status
          data = import_status_for DocumentGenerator.material_parse_job
          render json: data, status: :ok
        end

        def new
          @material_form = MaterialForm.new(source_type: params[:source_type].presence || 'gdoc')
        end

        def reimport_selected
          bulk_import @materials.map(&:file_url)
          render :import
        end

        private

        def create_async
          bulk_import(Array.wrap(form_params[:link]))
          render :import
        end

        def create_sync
          if @material_form.save
            material = @material_form.material
            redirect_to dynamic_material_path(material),
                        notice: t('lcms.engine.admin.materials.create.success', name: material.name)
          else
            render :new
          end
        end

        def bulk_import(files)
          jobs = {}
          files.each do |url|
            job_id = DocumentGenerator.material_parse_job.perform_later(url).job_id
            jobs[job_id] = { link: url, status: 'waiting' }
          end
          @props = { jobs: jobs, type: :materials, links: view_links }
        end

        def find_selected
          return head(:bad_request) unless params[:selected_ids].present?

          ids = params[:selected_ids].split(',')
          @materials = Material.where(id: ids)
        end

        def form_params
          params.require(:material_form).permit(:async, :link, :source_type)
        end

        def gdoc_files_from(url)
          folder_id = ::Lt::Google::Api::Drive.folder_id_for(url)
          if form_params[:source_type] == 'pdf'
            mime_type = Lt::Lcms::Lesson::Downloader::PDF::MIME_TYPE
            ::Lt::Google::Api::Drive.new(google_credentials)
              .list_file_ids_in(folder_id, mime_type: mime_type)
              .map { |id| ::Lt::Lcms::Lesson::Downloader::PDF.gdoc_file_url(id) }
          else
            ::Lt::Google::Api::Drive.new(google_credentials)
              .list_file_ids_in(folder_id)
              .map { |id| ::Lt::Lcms::Lesson::Downloader::Gdoc.gdoc_file_url(id) }
          end
        end

        def set_query_params
          @query_params = params[:query]
            &.permit(
              :course, :lesson, :name_date, :orientation, :search_term, :search_file_name, :sort_by, :title, :type,
              :unit
            ) || {}
        end
      end
    end
  end
end
