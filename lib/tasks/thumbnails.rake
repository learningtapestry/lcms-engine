# frozen_string_literal: true

namespace :thumbnails do # rubocop:disable Metrics/BlockLength
  desc 'generate thumbnail images'
  namespace :generate do
    task resources: [:environment] do
      generate_thumbnails 'Resources', Resource.tree
    end

    task others: [:environment] do
      generate_thumbnails 'Media    ', Resource.media
      generate_thumbnails 'Generic  ', Resource.generic_resources
    end

    task all: %i(others resources) do
    end

    def build_progressbar(name, qset)
      ProgressBar.create title: "Generate thumbnails for #{name}", total: qset.count
    end

    def generate_thumbnails(name, qset)
      pbar = build_progressbar name, qset
      qset.find_in_batches do |group|
        group.each do |item|
          GenerateThumbnails.new(item).generate
          pbar.increment
        end
      end
      pbar.finish
    end
  end

  task update: [:environment] do
    # first time we have run the thumbnails
    origin_time = Settings[:thumbnails_last_update].presence || '2017-01-23T16:25:00+00:00'

    last_update = DateTime.parse origin_time
    new_update_time = DateTime.current

    update_thumbs Resource.tree.where('updated_at > ?', last_update)

    update_thumbs Resource.media.where('updated_at > ?', last_update)
    update_thumbs Resource.generic_resources.where('updated_at > ?', last_update)

    Settings[:thumbnails_last_update] = new_update_time
  end

  def update_thumbs(data)
    pbar = ProgressBar.create title: "Update thumbnails (#{data.count})", total: data.count
    data.find_in_batches do |group|
      group.each do |item|
        GenerateThumbnails.new(item).generate
        pbar.increment
      end
    end
    pbar.finish
  end
end
