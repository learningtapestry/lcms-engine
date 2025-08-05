# frozen_string_literal: true

#
# Handler class for custom deprecation notifications.
# Used to output deprecation call messages to STDERR.
# @see spec/dummy/config/environments/test.rb:38
#
# rubocop:disable Style/StderrPuts
class CustomDeprecationHandler
  def call(message, callstack, _deprecation_horizon, gem_name)
    $stderr.puts "[#{Time.now}] #{message}"
    $stderr.puts "Gem: #{gem_name}"
    $stderr.puts callstack.join("\n")
    $stderr.puts '---'
  end
end
# rubocop:enable Style/StderrPuts
