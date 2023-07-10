# frozen_string_literal: true

require 'lt/google/api/auth/cli'

module Lcms
  module Engine
    class MaterialParseJob < Lcms::Engine::ApplicationJob
      include ResqueJob

      queue_as :default

      #
      # @param [Integer|String] id_or_url
      # @param [Hash] options
      #
      def perform(id_or_url, options = {})
        url =
          if id_or_url.is_a?(String)
            id_or_url
          else
            Lcms::Engine::Material.find(id_or_url).file_url
          end
        form = MaterialForm.new({ link: url }, import_retry: true)
        res = if form.save
                { ok: true, link: url, model: form.material }
              else
                { ok: false, link: url, errors: form.errors[:link] }
              end
        store_result(res, options)
      rescue StandardError => e
        res = { ok: false, link: id_or_url, errors: [e.message] }
        store_result(res, options)
      end
    end
  end
end
