# frozen_string_literal: true

module Lcms
  module Engine
    module Reimportable
      private

      def create_from_folder
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
            status: status,
            result: (status == :done ? job_class.fetch_result(jid) : nil)
          }.compact
        end
      end
    end
  end
end
