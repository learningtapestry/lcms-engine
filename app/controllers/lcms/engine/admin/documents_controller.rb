# frozen_string_literal: true

require 'lt/lcms/lesson/downloader/gdoc'

module Lcms
  module Engine
    module Admin
      class DocumentsController < AdminController
        include Lcms::Engine::GoogleCredentials
        include Reimportable

        before_action :find_selected, only: %i(destroy_selected reimport_selected)

        def index
          @query = OpenStruct.new(params[:query])
          @documents = DocTemplate.config['queries']['document'].constantize.call(@query, page: params[:page])
          render_customized_view
        end

        def create
          if form_params[:link].match?(RE_GOOGLE_FOLDER)
            # Import all from a folder
            file_ids = gdoc_files_from form_params[:link]
            return bulk_import(file_ids) && render(:import) if file_ids.any?

            flash.now[:alert] = t '.empty_folder'
            return render(:new)
          end

          @document = reimport_lesson
          if @document.save
            redirect_to AdminController.document_path(@document.document),
                        notice: t('.success', name: @document.document.name, errors: collect_errors)
          else
            render :new
          end
        end

        def destroy
          @document = Document.find(params[:id])
          @document.destroy
          redirect_to admin_documents_path(query: params[:query]), notice: t('.success')
        end

        def destroy_selected
          count = @documents.destroy_all.count
          redirect_to admin_documents_path(query: params[:query]), notice: t('.success', count: count)
        end

        def import_status
          data = import_status_for DocumentGenerator.document_parse_job
          render json: data, status: :ok
        end

        def new
          @document = DocumentForm.new
        end

        def reimport_selected
          bulk_import @documents
          render :import
        end

        private

        def bulk_import(docs)
          reimport_materials = params[:with_materials].to_i.nonzero?
          jobs = docs.each_with_object({}) do |doc, jobs_|
            job_id = DocumentGenerator.document_parse_job
                       .perform_later(doc, reimport_materials: reimport_materials).job_id
            link = doc.is_a?(Document) ? doc.file_url : doc
            jobs_[job_id] = { link: link, status: 'waiting' }
          end
          @props = { jobs: jobs, type: :documents, links: view_links }
        end

        def collect_errors
          return if @document.service_errors.empty?

          "Errors: #{@document.service_errors.join(' ')}"
        end

        def find_selected
          return head(:bad_request) unless params[:selected_ids].present?

          ids = params[:selected_ids].split(',')
          @documents = Document.where(id: ids)
        end

        def gdoc_files_from(url)
          folder_id = ::Lt::Google::Api::Drive.folder_id_for(url)
          ::Lt::Google::Api::Drive.new(google_credentials)
            .list_file_ids_in(folder_id)
            .map { |id| ::Lt::Lcms::Lesson::Downloader::Gdoc.gdoc_file_url(id) }
        end

        def form_params
          @form_params ||=
            begin
              data = params.require(:document_form).permit(:link, :link_fs, :reimport, :with_materials)
              data.delete(:with_materials) if data[:with_materials].to_i.zero?
              data
            end
        end

        def reimport_lesson
          reimport_lesson_materials if form_params[:with_materials].present?

          DocumentForm.new form_params.except(:with_materials)
        end

        def reimport_lesson_materials
          file_id = ::Lt::Lcms::Lesson::Downloader::Base.file_id_for form_params['link']
          doc = Document.actives.find_by(file_id: file_id)
          return unless doc

          doc.materials.each do |material|
            MaterialForm.new({ link: material.file_url, source_type: material.source_type }, google_credentials).save
          end
        end
      end
    end
  end
end
