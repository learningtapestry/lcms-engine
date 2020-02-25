# frozen_string_literal: true

require_relative 'version'

module Lcms
  module Engine
    if Rails::VERSION::MAJOR >= 5
      class Migration < ActiveRecord::Migration[RAILS_5_VERSION]
      end
    else
      # Rails 4 migrations are not versioned.
      class Migration < ActiveRecord::Migration
      end
    end
  end
end
