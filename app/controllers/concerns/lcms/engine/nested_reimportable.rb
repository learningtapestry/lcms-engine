# frozen_string_literal: true

module Lcms
  module Engine
    module NestedReimportable
      private

      def import_status_for(job_class)
        params.fetch(:jids, []).each_with_object({}) do |jid, obj|
          status = job_class.status_nested(jid)
          obj[jid] = {
            status: status,
            result: (status == :done ? flatten_result(job_class, jid) : nil)
          }.compact
        end
      end

      def flatten_result(job_class, jid)
        jid_res = job_class.fetch_result(jid)
        return jid_res if (failed = job_class.fetch_result_nested(jid).reject { |j| j['ok'] }).blank?

        { ok: false, errors: jid_res&.dig('errors') || [] }.tap do |failed_result|
          failed.each do |e|
            failed_result[:errors] << "<a href=\"#{e['link']}\">Source</a>: #{e['errors'].join(', ')}"
          end
        end
      end
    end
  end
end
