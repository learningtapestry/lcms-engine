# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment', __dir__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

require 'email_spec'
require 'email_spec/rspec'
require 'faker'

Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each(&method(:require))
Dir[File.expand_path('**/shared_examples/*.rb')].sort.each(&method(:require))

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.before(:suite) do
    # Rails 4.2 call `initialize` inside `recycle!`. However Ruby 2.6 doesn't allow calling `initialize` twice.
    # See for detail: https://github.com/rails/rails/issues/34790
    if RUBY_VERSION.to_f >= 2.6 && Rails::VERSION::MAJOR == 4
      class ActionController::TestResponse # rubocop:disable Style/ClassAndModuleChildren
        prepend Module.new {
          def recycle!
            # Patch to avoid MonitorMixin double-initialize error:
            @mon_mutex_owner_object_id = nil
            @mon_mutex = nil
            super
          end
        }
      end
    end
  end
end
