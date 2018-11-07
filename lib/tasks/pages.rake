# frozen_string_literal: true

namespace :pages do
  desc 'Update pages from seed'
  task update: :environment do
    pages_to_replace = %w(tos privacy)
    Page.where(slug: pages_to_replace).each(&:destroy)
    Rake::Task['db:seed:pages'].invoke
  end
end
