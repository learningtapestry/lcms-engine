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
          @document_form = DocumentForm.new(form_params.except(:async, :with_materials))

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
          @document_form = DocumentForm.new
        end

        def reimport_selected
          bulk_import @documents.map(&:file_url)
          render :import
        end

        private

        def create_async
          bulk_import Array.wrap(form_params[:link])
          render :import
        end

        def create_sync
          reimport_lesson_materials if form_params[:with_materials].present?

          if @document_form.save
            flash_message =
              if collect_errors.empty?
                { notice: t('lcms.engine.admin.documents.create.success', name: @document_form.document.name) }
              else
                { alert: t('lcms.engine.admin.documents.create.error',
                           name: @document_form.document.name,
                           errors: collect_errors) }
              end
            redirect_to dynamic_document_path(@document_form.document), **flash_message
          else
            render :new
          end
        end

        #
        # @param [Array<String>] file_urls
        #
        def bulk_import(file_urls)
          reimport_materials = params[:with_materials].to_i.nonzero?
          jobs = file_urls.each_with_object({}) do |url, jobs_|
            job_id = DocumentGenerator.document_parse_job.perform_later(url, reimport_materials:).job_id
            jobs_[job_id] = { link: url, status: 'waiting' }
          end
          polling_path = lcms_engine.import_status_admin_documents_path
          @props =
            { jobs:, links: view_links, polling_path:, type: :documents }
              .transform_keys! { _1.to_s.camelize(:lower) }
        end

        def collect_errors
          @collect_errors ||=
            if @document_form.service_errors.empty?
              []
            else
              @document_form.service_errors.map { "<li>#{_1}</li>" }.join
            end
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
              data = params.require(:document_form).permit(:async, :link, :with_materials).to_h
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
              :broken_materials,
              :course,
              :grade,
              :inactive,
              :locale,
              :module,
              :only_failed,
              :reimport_required,
              :search_term,
              :sort_by,
              :subject,
              :unit,
              grades: []
            ) || {}
        end
      end
    end
  end
end
