# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class MaterialsController < AdminController
        include Lcms::Engine::GoogleCredentials
        include Reimportable

        before_action :find_selected, only: %i(destroy_selected reimport_selected)

        def index
          @query = OpenStruct.new params[:query]
          @materials = DocTemplate.config['queries']['material'].constantize.call(@query, page: params[:page])
          render_customized_view
        end

        def create
          return bulk_import(gdoc_files) && render(:import) if gdoc_files.size > 1

          @material_form = DocumentGenerator.material_form.new(form_params)
          if @material_form.save
            material = @material_form.material
            redirect_to AdminController.material_path(material.id), notice: t('.success', name: material.name)
          else
            render :new
          end
        end

        def destroy
          material = Material.find(params[:id])
          material.destroy
          redirect_to admin_materials_path(query: params[:query]), notice: t('.success')
        end

        def destroy_selected
          count = @materials.destroy_all.count
          redirect_to admin_materials_path(query: params[:query]), notice: t('.success', count: count)
        end

        def import_status
          data = import_status_for MaterialParseJob
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

        def bulk_import(files)
          jobs = {}
          files.each do |url|
            job_id = MaterialParseJob.perform_later(url).job_id
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
          params.require(:material_form).permit(:link, :source_type)
        end

        def gdoc_files
          @gdoc_files ||= begin
            link = form_params[:link]
            return [link] unless link =~ %r{/drive/(.*/)?folders/}

            folder_id = ::Lt::Google::Api::Drive.folder_id_for(link)
            if form_params[:source_type] == 'pdf'
              mime_type = Lt::Lcms::Lesson::Downloader::PDF::MIME_TYPE
              ::Lt::Google::Api::Drive.new(google_credentials)
                .list_file_ids_in(folder_id, mime_type: mime_type)
                .map { |id| Lt::Lcms::Lesson::Downloader::PDF.gdoc_file_url(id) }
            else
              ::Lt::Google::Api::Drive.new(google_credentials)
                .list_file_ids_in(folder_id)
                .map { |id| Lt::Lcms::Lesson::Downloader::Gdoc.gdoc_file_url(id) }
            end
          end
        end
      end
    end
  end
end
