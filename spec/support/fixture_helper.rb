# frozen_string_literal: true

module FixtureHelper
  def file_fixture(fixture_name)
    file_fixture_path = ::Rails.root.join('..', 'fixtures')
    path = Pathname.new(File.join(file_fixture_path, fixture_name))
    raise ArgumentError, "the directory '#{file_fixture_path}' does not contain a file named '#{fixture_name}'" \
      unless path.exist?

    path
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
