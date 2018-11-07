# frozen_string_literal: true

namespace :es do
  desc 'Reset Index'
  task reset: :environment do
    if repo.index_exists?
      puts "Deleting Index: #{repo.index}"
      repo.delete_index!
    end

    puts "Creating Index: #{repo.index}"
    repo.create_index!
  end

  desc 'Indexes models'
  task index_models: :environment do
    repo.create_index!

    index_model 'Resources', Resource.tree.where.not(curriculum_type: 'subject')
    index_model 'Media    ', Resource.media
    index_model 'Generic  ', Resource.generic_resources
  end

  desc 'Load index'
  task load: %i(environment index_models) do
    fpath = Rails.root.join('db', 'seeds', 'external_pages.json')
    pages = JSON.parse File.read(fpath)
    pages.each do |page_attrs|
      page = ExternalPage.new(page_attrs.symbolize_keys)
      repo.klass.build_from(page).index!
    end
  end

  def repo
    @repo ||= Search::Repository.new
  end

  def index_model(name, qset)
    pbar = ProgressBar.create title: "Indexing #{name}", total: qset.count

    qset.find_in_batches do |group|
      group.each do |item|
        repo.klass.build_from(item).index!
        pbar.increment
      end
    end
    pbar.finish
  end
end
