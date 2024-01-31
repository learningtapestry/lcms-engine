# frozen_string_literal: true

module Lcms
  module Engine
    module NestedReimportable
      private

      #
      # @param job_class [Class] The job class.
      # @return [Hash] The status of the job.
      #
      def import_status_for(job_class)
        params.fetch(:jids, []).each_with_object({}) do |jid, obj|
          status = job_class.status_nested(jid)
          obj[jid] = {
            status:,
            result: (status == :done ? flatten_result(job_class, jid) : nil)
          }.compact
        end
      end

      #
      # @param job_class [Class] The job class.
      # @param jid [String] The job ID.
      # @return [Hash] The result of the job.
      #
      def flatten_result(job_class, jid)
        jid_res = job_class.fetch_result(jid)
        result_nested = job_class.fetch_result_nested(jid)
        # Return in case of no errors
        return jid_res unless result_nested.any? { _1['ok'] == false }

        { ok: false, errors: jid_res&.[]('errors') || [] }.tap do |failed_result|
          result_nested.each do |e|
            failed_result[:errors] << "<a href=\"#{e['link']}\">Source</a>: #{e['errors'].join(', ')}"
          end
        end
      end
    end
  end
end
