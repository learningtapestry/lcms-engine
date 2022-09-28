# frozen_string_literal: true

require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV.fetch('ELASTICSEARCH_ADDRESS', nil)
)
Hashie.logger = Logger.new('/dev/null')
