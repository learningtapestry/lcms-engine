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
end
