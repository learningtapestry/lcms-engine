# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentsController < Lcms::Engine::ApplicationController
      skip_before_action :verify_authenticity_token, only: :show_lti
      skip_before_action :authenticate_user!, only: :show_lti

      before_action :set_document
      before_action :check_document_layout, only: :show
      before_action :check_params, only: :export

      def export
        @excludes = params[:excludes]
        @type = params[:type]
        params[:context] == 'pdf' ? export_pdf : export_gdoc
      end

      def export_status
        job_class = params[:context] == 'pdf' ? DocumentGeneratePdfJob : DocumentGenerateGdocJob
        job = job_class.find(params[:jid])
        data = { ready: job.nil? }
        data = data.merge(url: @doc.tmp_link(params[:key])) if params[:key] && job.nil?
        render json: data, status: :ok
      end

      def show
        @props = CurriculumMap.new(@document.resource).props
      end

      def show_lti
        # To allow access from iFrame element
        response.headers.delete 'X-Frame-Options'

        @props = CurriculumMap.new(@document.resource).props.merge(links_new_tab: true)

        render layout: 'lti'
      end

      private

      attr_reader :excludes, :type

      def check_document_layout
        return if @document.layout('default').present?

        redirect_to admin_documents_path, alert: 'Document has to be re-imported.'
      end

      def check_params
        head :bad_request unless params[:type].present? && params[:context].present?
      end

      def export_gdoc
        return render(json: { url: @doc.links[@document.gdoc_key] }, status: :ok) if excludes.blank?

        folder = "#{@document.gdoc_folder}_#{SecureRandom.hex(10)}"
        options = {
          bundle: (type == 'full'),
          excludes: excludes,
          gdoc_folder: folder,
          content_type: type
        }
        job_id = DocumentGenerateGdocJob.perform_later(@doc, options).job_id

        render json: { id: job_id, key: folder }, status: :ok
      end

      def export_pdf
        # Empty excludes - return pregenerated full PDF
        return render(json: { url: @doc.links[pdf_key(type)] }, status: :ok) if excludes.blank?

        filename = "documents-custom/#{SecureRandom.hex(10)}-#{@document.pdf_filename}"
        url = S3Service.url_for(filename)
        options = {
          excludes: excludes,
          filename: filename,
          content_type: type
        }
        job_id = DocumentGeneratePdfJob.perform_later(@doc, options).job_id

        render json: { id: job_id, url: url }, status: :ok
      end

      def pdf_key(pdf_type)
        pdf_type == 'full' ? 'pdf' : "pdf_#{pdf_type}"
      end

      def set_document
        @doc = Document.find params[:id]
        @document = DocumentPresenter.new @doc, content_type: params[:type]
      end
    end
  end
end
