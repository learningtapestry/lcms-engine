# frozen_string_literal: true

require 'lt/google/api/auth/cli'

class DocumentParseJob < Lcms::Engine::ApplicationJob
  include ResqueJob
  include RetryDelayed

  queue_as :default

  def perform(entry, options = {})
    if entry.is_a?(Document)
      @document = entry
      reimport_materials if options[:reimport_materials].present?
      reimport_document(@document.file_url) if result.nil?

      @document.update(reimported: false) unless result[:ok]
    else
      reimport_document entry
    end

    store_result result, options
  end

  private

  attr_reader :document, :result

  def reimport_document(link)
    form = DocumentForm.new({ link: link }, import_retry: true)
    @result = if form.save
                { ok: true, link: link, model: form.document }
              else
                { ok: false, link: link, errors: form.errors[:link] }
              end
  end

  def reimport_materials
    document.materials.each do |material|
      link = material.file_url
      form = MaterialForm.new({ link: link, source_type: material.source_type }, import_retry: true)
      next if form.save

      error_msg = %(Material error (<a href="#{link}">source</a>): #{form.errors[:link]})
      @result = { ok: false, link: link, errors: [error_msg] }
      break
    end
  end
end
