# frozen_string_literal: true

module Lcms
  module Engine
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc 'Copies all required configuration files.'

        source_root File.expand_path('templates', __dir__)

        def copy_config_files
          directory File.expand_path('templates/config', __dir__), Rails.root.join('config')
        end

        def update_gemfile
          # Rails-assets.org is needed to fetch required gems (rails-assets-*)
          add_source 'https://rails-assets.org'

          # Required by lcms-engine because of unpublished gems are not automatically installed with the parent gem
          gem 'wicked_pdf', git: 'https://github.com/learningtapestry/wicked_pdf.git',
                            branch: 'puppeteer-support',
                            ref: 'c807f6b4'
        end
      end
    end
  end
end
