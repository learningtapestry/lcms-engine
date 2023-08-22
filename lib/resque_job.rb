# frozen_string_literal: true

module ResqueJob
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    def find(job_id)
      find_in_queue(job_id) || find_in_working(job_id)
    end

    def find_in_queue(job_id)
      Resque.peek(queue_name, 0, 0)
        .map { |job| job['args'].first }
        .detect { |job| job['job_id'] == job_id }
    end

    def find_in_queue_by_payload(job_class, &)
      jobs = Array.wrap Resque.peek(queue_name, 0, 0)
      result = jobs
                 .select { |j| j['args'].first['job_class'] == job_class.to_s }
                 .flat_map { |j| j['args'] }
      return result unless block_given?

      result.detect(&)
    end

    def find_in_working(job_id)
      Resque::Worker.working.map(&:job).detect do |job|
        if job.is_a?(Hash) && (args = job.dig 'payload', 'args').is_a?(Array)
          args.detect { |x| x['job_id'] == job_id }
        end
      end
    end

    def find_in_working_by_payload(job_class, &)
      result =
        Resque::Worker.working.map(&:job).flat_map do |job|
          next unless job.is_a?(Hash) && (args = job.dig 'payload', 'args').is_a?(Array)

          args.select { |x| x['job_class'] == job_class.to_s }
        end.compact
      return result unless block_given?

      result.detect(&)
    end

    def fetch_result(job_id)
      res = Resque.redis.get result_key(job_id)
      JSON.parse(res) rescue res
    end

    def result_key(job_id)
      [Resque.redis.namespace, 'result', name.underscore, job_id].join(':')
    end

    def status(job_id)
      if find_in_queue(job_id)
        :waiting
      elsif find_in_working(job_id)
        :running
      else
        :done
      end
    end
  end

  def result_key
    @result_key ||= self.class.result_key(job_id)
  end

  def store_initial_result(res, options = {})
    key = self.class.result_key(options[:initial_job_id].presence || job_id)
    Resque.redis.set(key, res.to_json, ex: 1.hour.to_i)
  end

  #
  # @param [Hash] res
  # @param [Hash] options
  #
  def store_result(res, options = {})
    key = if (jid = options[:initial_job_id]).blank?
            result_key
          else
            # store result with parent job id to retrieve the result later knowing only parent job id
            [Resque.redis.namespace, 'result', self.class.name.to_s.underscore, jid, job_id].join(':')
          end
    Resque.redis.set(key, res.to_json, ex: 1.hour.to_i)
  end
end
