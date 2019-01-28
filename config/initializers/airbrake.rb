# frozen_string_literal: true

project_id = ENV['AIR_BRAKE_PROJECT_ID']
project_key = ENV['AIR_BRAKE_PROJECT_KEY']

AIRBRAKE_ENABLED = project_id.present? && project_key.present?

if AIRBRAKE_ENABLED
  Airbrake.configure do |c|
    c.project_id = project_id
    c.project_key = project_key

    c.root_directory = Rails.root
    c.logger = Rails.logger
    c.environment = Rails.env
    c.blacklist_keys = Rails.application.config.filter_parameters

    c.ignore_environments = %w(test)
  end

  ignore_errors = %w(
    AbstractController::ActionNotFound
    ActiveRecord::RecordNotFound
    SignalException
  )

  Airbrake.add_filter do |notice|
    notice.ignore! if notice[:errors].any? { |error| ignore_errors.include?(error[:type]) }
  end
end

# If Airbrake doesn't send any expected exceptions, we suggest to uncomment the
# line below. It might simplify debugging of background Airbrake workers, which
# can silently die.
# Thread.abort_on_exception = ['test', 'development'].include?(Rails.env)
