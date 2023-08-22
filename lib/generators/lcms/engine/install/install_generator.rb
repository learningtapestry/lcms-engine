# frozen_string_literal: true

module Lcms
  module Engine
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc 'Copies all required configuration files.'

        source_root File.expand_path('templates', __dir__.to_s)

        def copy_config_files
          directory File.expand_path('templates/config', __dir__.to_s), Rails.root.join('config')
        end

        def update_gemfile
          # Required by lcms-engine because of unpublished gems are not automatically installed with the parent gem
          gem 'wicked_pdf', git: 'https://github.com/learningtapestry/wicked_pdf.git',
                            branch: 'puppeteer-support',
                            ref: '964a090'
        end
      end
    end
  end
end
