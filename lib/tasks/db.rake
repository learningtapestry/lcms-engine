# frozen_string_literal: true

namespace :db do # rubocop:disable Metrics/BlockLength
  desc 'Backs up the database.'
  task backup: [:environment] do
    config = ActiveRecord::Base.connection_db_config.configuration_hash

    backup_cmd = <<-BASH
      BACKUP_FOLDER=$HOME/database_backups/`date +%Y_%m_%d`
      BACKUP_NAME=unbounded_`date +%s`.dump
      BACKUP_PATH=$BACKUP_FOLDER/$BACKUP_NAME

      mkdir -p $BACKUP_FOLDER

      PGPASSWORD=#{config[:password]} pg_dump \
          -h #{config[:host] || 'localhost'} \
          -U #{config[:username]} \
          --no-owner \
          --no-acl \
          -n public \
          -F c \
          #{config[:database]} \
          > $BACKUP_PATH

      echo "-> Backup created in $BACKUP_PATH."
    BASH

    puts "Backing up #{Rails.env} database."

    raise unless system(backup_cmd)
  end

  desc 'Dumps the database. Will create a dump file in db/dump/content.dump or a custom path.'
  task :dump, [:dump_path] do |_t, args|
    config = ActiveRecord::Base.connection_db_config.configuration_hash
    dump_path = args[:dump_path] || "#{Rails.root}/db/dump/content.dump"

    dump_cmd = <<-BASH
      PGPASSWORD=#{config[:password]} \
      pg_dump \
        --port #{config[:port]} \
        --host #{config[:host]} \
        --username #{config[:username]} \
        --clean \
        --no-owner \
        --no-acl \
        --format=c \
        -n public \
        #{config[:database]} > #{dump_path}
    BASH

    puts "Dumping #{Rails.env} database to #{dump_path}."

    raise unless system(dump_cmd)
  end

  desc 'Runs pg_restore. Requires a dump file in db/dump/content.dump or a custom path.'
  task :pg_restore, [:dump_path] do |_t, args|
    config = ActiveRecord::Base.connection_db_config.configuration_hash
    dump_path = args[:dump_path] || "#{Rails.root}/db/dump/content.dump"

    restore_cmd = <<-BASH
      PGPASSWORD=#{config[:password]} \
      pg_restore \
        --port=#{config[:port]} \
        --host=#{config[:host]} \
        --username=#{config[:username]} \
        --no-owner \
        --no-acl \
        -n public \
        --dbname=#{config[:database]} #{dump_path}
    BASH

    puts "Restoring #{Rails.env} database from #{dump_path}."

    raise unless system(restore_cmd)
  end

  desc 'Drops, creates and restores the database from a dump.'
  task restore: %i(drop create environment pg_restore)
end
