# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class DocumentsController < AdminController
        include Lcms::Engine::GoogleCredentials
        include Lcms::Engine::PathHelper
        include Reimportable

        before_action :find_selected, only: %i(destroy_selected reimport_selected)
        before_action :set_query_params

        def index
          @query = OpenStruct.new @query_params # rubocop:disable Style/OpenStructUse
          @documents = DocTemplate.config['queries']['document'].constantize.call(@query, page: params[:page])
          render_customized_view
        end

        def create
          @document = DocumentForm.new(form_params.except(:async, :with_materials))

          return create_multiple if form_params[:link].match?(RE_GOOGLE_FOLDER)

          form_params[:async].to_i.zero? ? create_sync : create_async
        end

        def destroy
          @document = Document.find(params[:id])
          @document.destroy
          redirect_to lcms_engine.admin_documents_path(query: @query_params), notice: t('.success')
        end

        def destroy_selected
          count = @documents.destroy_all.count
          redirect_to lcms_engine.admin_documents_path(query: @query_params), notice: t('.success', count:)
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

        def create_async
          bulk_import(Array.wrap(form_params[:link]))
          render :import
        end

        def create_sync
          reimport_lesson_materials if form_params[:with_materials].present?
          if @document.save
            notice = t('lcms.engine.admin.documents.create.success',
                       name: @document.document.name,
                       errors: collect_errors)
            redirect_to dynamic_document_path(@document.document), notice:
          else
            render :new
          end
        end

        def bulk_import(docs)
          reimport_materials = params[:with_materials].to_i.nonzero?
          jobs = docs.each_with_object({}) do |doc, jobs_|
            job_id = DocumentGenerator.document_parse_job
                       .perform_later(doc, reimport_materials:).job_id
            link = doc.is_a?(Document) ? doc.file_url : doc
            jobs_[job_id] = { link:, status: 'waiting' }
          end
          @props = { jobs:, type: :documents, links: view_links }
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
              data = params.require(:document_form).permit(:async, :link, :link_fs, :reimport, :with_materials).to_h
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
          doc = Document.actives.find_by(file_id:)
          return unless doc

          doc.materials.each do |material|
            MaterialForm.new({ link: material.file_url, source_type: material.source_type }, google_credentials).save
          end
        end

        def set_query_params
          @query_params = params[:query]
            &.permit(
              :broken_materials, :course, :grade, :inactive, :locale, :module, :only_failed, :reimport_required,
              :search_term, :sort_by
            ) || {}
        end
      end
    end
  end
end
