# frozen_string_literal: true

require 'lt/google/api/auth/cli'

module Lcms
  module Engine
    class MaterialParseJob < Lcms::Engine::ApplicationJob
      include ResqueJob

      queue_as :default

      def perform(entry, options = {})
        attrs = attributes_for entry
        form = MaterialForm.new(attrs, import_retry: true)
        res = if form.save
                { ok: true, link: attrs[:link], model: form.material }
              else
                { ok: false, link: attrs[:link], errors: form.errors[:link] }
              end
        store_result res, options
      end

      private

      def attributes_for(entry)
        {}.tap do |data|
          data[:link] = entry.is_a?(Material) ? entry.file_url : entry
          data[:source_type] = entry.source_type if entry.is_a?(Material)
        end
      end
    end
  end
end
