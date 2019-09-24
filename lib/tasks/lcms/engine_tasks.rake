# frozen_string_literal: true

namespace :lcms_engine do # rubocop:disable Metrics/BlockLength
  desc 'Copy routes file'
  task :copy_routes do
    src = File.join Lcms::Engine::Engine.root, 'templates', 'routes.rb'
    dst = File.join Rails.root, 'config', 'routes.rb'
    FileUtils.copy_file src, dst
  end

  desc 'Loads the initial schema inside the DB'
  task load_default_schema: :environment do
    file = File.expand_path '../../../db/schema.rb', __dir__
    if File.exist?(file)
      load(file)
    else
      abort "Schema file #{file} doesn't exist."
    end
  end

  desc 'Seed the DB with data'
  task seed_data: :environment do
    load File.join Lcms::Engine::Engine.root, 'db', 'seeds.rb'
  end

  namespace :webpacker do
    desc 'Cleans the Webpack output folder (public/lcms_engine_packs)'
    task :clean_output_folder do
      puts 'Destroying packs output folder ...'
      Dir.chdir(File.join(__dir__, '..', '..')) do
        # TODO : Load packs output from config/webpacker.yml
        system 'rm -rf public/lcms_engine_packs'
      end
    end

    desc 'Install deps with yarn'
    task :yarn_install do
      Dir.chdir(File.join(__dir__, '../..')) do
        system 'yarn install --no-progress --production'
      end
    end

    desc 'Compile JavaScript packs using webpack for production with digests'
    task compile: %i(clean_output_folder yarn_install environment) do
      Webpacker.with_node_env('production') do
        if Lcms::Engine.webpacker.commands.compile
          # Successful compilation!
        else
          # Failed compilation
          exit!
        end
      end
    end
  end
end

def yarn_install_available?
  rails_major = Rails::VERSION::MAJOR
  rails_minor = Rails::VERSION::MINOR

  rails_major > 5 || (rails_major == 5 && rails_minor >= 1)
end

def enhance_assets_precompile
  # yarn:install was added in Rails 5.1
  deps = yarn_install_available? ? [] : ['lcms_engine:webpacker:yarn_install']
  Rake::Task['assets:precompile'].enhance(deps) do
    Rake::Task['lcms_engine:webpacker:compile'].invoke
  end
end

# Compile packs after we've compiled all other assets during precompilation
skip_webpacker_precompile = %w(no false n f).include?(ENV['WEBPACKER_PRECOMPILE'])

unless skip_webpacker_precompile
  if Rake::Task.task_defined?('assets:precompile')
    enhance_assets_precompile
  else
    Rake::Task.define_task('assets:precompile' => 'lcms_engine:webpacker:compile')
  end
end
