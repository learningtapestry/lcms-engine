# frozen_string_literal: true

require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV['ELASTICSEARCH_ADDRESS']
)
Hashie.logger = Logger.new('/dev/null')
