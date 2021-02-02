# frozen_string_literal: true

module Lcms
  module Engine
    module NestedResqueJob
      extend ActiveSupport::Concern

      class_methods do # rubocop:disable Metrics/BlockLength
        def queued_or_running_nested?(job_id, current_job_id = -1)
          check_child = ->(j) { j['arguments'][1]&.dig('initial_job_id') == job_id && j['job_id'] != current_job_id }
          job_klasses = self::NESTED_JOBS + [name]
          job_klasses.each do |job_klass|
            queued = find_in_queue_by_payload(job_klass, &check_child) ||
                     find_in_working_by_payload(job_klass, &check_child)
            return true if queued.present?
          end
          false
        end

        def status_nested(jid)
          self_status = status(jid)
          return self_status unless self_status == :done
          return :running if queued_or_running_nested?(jid)

          :done
        end

        def fetch_result_nested(jid)
          [].tap do |result|
            self::NESTED_JOBS.each do |job_klass|
              Resque.redis.scan_each(match: "#{job_klass.constantize.result_key(jid)}*") do |key|
                res = Resque.redis.get key
                result << JSON.parse(res) rescue res
              end
            end
          end
        end
      end

      private

      def initial_job_id
        @initial_job_id ||= options[:initial_job_id].presence || job_id
      end
    end
  end
end
