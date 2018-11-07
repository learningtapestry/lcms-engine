# frozen_string_literal: true

namespace :cloud66 do # rubocop:disable Metrics/BlockLength
  desc 'Post-symlink hook tasks for Cloud66.'
  task after_symlink: %i(environment db:migrate db:seed)

  namespace :robots do
    desc 'Add robots.txt to public'
    task add: :environment do
      origin = Rails.root.join '.cloud66', 'public', 'staging', 'robots.txt'
      target = Rails.root.join 'public'
      FileUtils.cp origin, target
    end

    desc 'Deletes robots.txt from public'
    task remove: :environment do
      path = Rails.root.join 'public', 'robots.txt'
      FileUtils.rm path
    end
  end

  namespace :swap do
    SWAP_FILE = Rails.root.join 'export-swap.sql'

    desc 'Exports tables to be synced'
    task export: :environment do
      cmd = <<-BASH
        pg_dump -U #{ENV['POSTGRESQL_USERNAME']} #{ENV['POSTGRESQL_DATABASE']} \
          --no-owner \
          --table=users \
          --table=access_codes \
          --file=#{SWAP_FILE}
      BASH
      system cmd
    end

    desc 'Deletes existing tables and creates new one'
    task import: :environment do
      raise 'No data file. Please execute `cloud66:swap:export` prior loading the data.' unless File.exist?(SWAP_FILE)

      cmd = "psql -U #{ENV['POSTGRESQL_USERNAME']} #{ENV['POSTGRESQL_DATABASE']}"
      # Drops old tables
      system "#{cmd} -c 'drop table access_codes, users;'"
      # Create new and load the data
      system "#{cmd} < #{SWAP_FILE}"
    end
  end
end
