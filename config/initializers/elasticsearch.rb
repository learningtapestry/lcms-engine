# frozen_string_literal: true

require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV.fetch('ELASTICSEARCH_ADDRESS', nil),
  adapter: :net_http
)
Hashie.logger = Logger.new('/dev/null')
