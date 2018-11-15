# frozen_string_literal: true

# TODO: Extract base functionality into `lt-google-api` gem
module Google
  class ScriptService
    include GoogleCredentials

    SCRIPT_ID = ENV.fetch('GOOGLE_APPLICATION_SCRIPT_ID', 'PLEASE SET UP SCRIPT ID')

    def initialize(document)
      @document = document
    end

    def execute(id)
      # Create an execution request object.
      request = Google::Apis::ScriptV1::ExecutionRequest.new(
        function: 'postProcessingUB',
        parameters: [id, gdoc_template_id, document.cc_attribution, document.full_breadcrumb, document.short_url]
      )
      response = service.run_script(SCRIPT_ID, request)
      return unless response.error

      # The API executed, but the script returned an error.
      error = response.error.details[0]
      msg = +"Script error message: #{error['errorMessage']}\n"
      if error['scriptStackTraceElements']
        msg << 'Script error stacktrace:'
        error['scriptStackTraceElements'].each do |trace|
          msg << "\t#{trace['function']}: #{trace['lineNumber']}"
        end
      end
      raise Google::Apis::Error, msg
    end

    private

    attr_reader :document

    def gdoc_template_id
      ENV.fetch("GOOGLE_APPLICATION_TEMPLATE_#{document&.orientation&.upcase || 'PORTRAIT'}")
    end

    def service
      @service ||=
        begin
          service = Google::Apis::ScriptV1::ScriptService.new
          service.authorization = google_credentials
          service
        end
    end
  end
end
