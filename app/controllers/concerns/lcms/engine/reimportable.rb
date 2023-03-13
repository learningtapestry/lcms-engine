# frozen_string_literal: true

module Lcms
  module Engine
    module Reimportable
      private

      def create_multiple
        # Import all from a folder
        file_ids = gdoc_files_from form_params[:link]
        return bulk_import(file_ids) && render(:import) if file_ids.any?

        flash.now[:alert] = t 'lcms.engine.admin.common.empty_folder'
        render(:new)
      end

      def import_status_for(job_class)
        params.fetch(:jids, []).each_with_object({}) do |jid, obj|
          status = job_class.status(jid)
          obj[jid] = {
            status:,
            result: (status == :done ? prepare_result(job_class, jid) : nil)
          }.compact
        end
      end

      def prepare_result(job_class, jid)
        jid_res = job_class.fetch_result(jid)
        return jid_res if jid_res['ok']

        {
          ok: false,
          errors: Array.wrap("<a href=\"#{jid_res['link']}\">Source</a>: #{jid_res['errors'].join(', ')}")
        }
      end
    end
  end
end
