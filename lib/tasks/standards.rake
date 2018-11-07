# frozen_string_literal: true

namespace :standards do
  namespace :import do
    desc 'Import ELA standards'
    task ela: [:environment] do
      StandardImporter.new(:ela).run
      puts 'Done.'
    end

    desc 'Import MATH standards'
    task math: [:environment] do
      StandardImporter.new(:math).run
      puts 'Done.'
    end
  end
end
