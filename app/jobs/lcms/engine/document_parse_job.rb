# frozen_string_literal: true

require 'lt/google/api/auth/cli'

module Lcms
  module Engine
    class DocumentParseJob < Lcms::Engine::ApplicationJob
      include ResqueJob
      include RetryDelayed

      queue_as :default

      #
      # Options can have:
      #  - reimport_materials - require materials re-import.
      #    If such option is passed, then at first try to import
      #    connected materials. If all is good - import document itself.
      #    If there were errors with materials - do not import document.
      #
      # @param [Integer|String] id_or_url
      # @param [Hash] options
      #
      def perform(id_or_url, options = {})
        @options = options

        if id_or_url.is_a?(String)
          reimport_document(id_or_url)
        else
          @options.merge!(is_reimport: true)
          reimport_by_id(id_or_url)
          @document.update(reimported: false) unless result[:ok]
        end

        store_result(result, options)
      rescue StandardError => e
        res = { ok: false, link: id_or_url, errors: [e.message] }
        store_result(res, options)
      end

      private

      attr_reader :document, :options, :result

      #
      # @param [Integer] id
      #
      def reimport_by_id(id)
        @document = Lcms::Engine::Document.find(id)
        reimport_materials if options[:reimport_materials].present?
        reimport_document(@document.file_url)
      end

      def reimport_document(link)
        form = DocumentForm.new({ link: }, options.merge(import_retry: true))
        @result = if form.save
                    { ok: true, link:, model: form.document, warnings: form.service_errors }
                  else
                    { ok: false, link:, errors: form.errors[:link] }
                  end
      end

      def reimport_materials
        document.materials.each do |material|
          link = material.file_url
          form = MaterialForm.new({ link:, source_type: material.source_type }, import_retry: true)
          next if form.save

          error_msg = %(Material error (<a href="#{link}">source</a>): #{form.errors[:link]})
          @result = { ok: false, link:, errors: [error_msg] }
          break
        end
      end
    end
  end
end
