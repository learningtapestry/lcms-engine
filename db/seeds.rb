# frozen_string_literal: true

dir = File.expand_path 'seeds', __dir__

seeds = %w(
  authors.seeds.rb
  curriculums.seeds.rb
  subjects.seeds.rb
  download_categories.seeds.rb
  pages.seeds.rb
  development/users.seeds.rb
  development/grades.seeds.rb
).freeze

seeds.map { |s| File.join dir, s }.each(&method(:load))
