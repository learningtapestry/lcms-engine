# frozen_string_literal: true

namespace :lcms_engine_engine do
  desc 'Copy routes file'
  task :copy_routes do
    src = File.join(Lcms::Engine::Engine.root, 'templates', 'routes.rb')
    dst = File.join(Rails.root, 'config', 'routes.rb')
    FileUtils.copy_file(src, dst)
  end
end
