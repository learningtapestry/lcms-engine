# frozen_string_literal: true

# Component is a simple abstraction for accessing the unbounded-component-search API
class Component < OpenStruct
  class << self
    def component_types
      @component_types ||= api_request('/types')
    end

    def find(id)
      resp = api_request "/#{id}"
      new resp
    end

    def search(params = {})
      resp = api_request '/', params
      paginated_results(resp)
    end

    private

    def api_request(path, params = {})
      res = HTTParty.get api_url(path),
                         query: params,
                         headers: { 'Authorization' => "Token token=\"#{api_token}\"" }
      parse_response(res)
    rescue URI::InvalidURIError, ComponentsAPIError => e
      Rails.logger.error("Error requesting the components API: path=#{path} params=#{params}")
      raise ComponentsAPIError, e.message
    end

    def api_token
      @api_token ||= ENV.fetch('UB_COMPONENTS_API_TOKEN')
    end

    def api_url(path)
      @base ||= ENV.fetch('UB_COMPONENTS_API_URL')
      @base + path
    end

    # We must build an ES response so we can reuse the pagination engine we
    # already have in place for the UI
    # The API response has the following attributes:
    #     page        : The current page
    #     per_page    : Number of results per page
    #     total       : Total of results on the db for this query
    #     results:    : The search results
    #     max_score:  : The maximum score obtained for this query
    def paginated_results(resp)
      resp = resp.with_indifferent_access
      Elasticsearch::Persistence::Repository::Response::Results.new(
        repo,
        hits: {
          total:     resp[:total],
          max_score: resp[:max_score],
          hits:      resp[:results]
        }
      ).paginate(resp.slice(:page, :per_page))
    end

    def parse_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        msg = "API error: status=#{response.code} message=#{response.message}"
        raise ComponentsAPIError, msg
      end
    end

    # The ES response requires a persistence-repository so we
    # can define how to deserialize the results
    def repo
      @repo ||= Elasticsearch::Persistence::Repository.new do
        def deserialize(document) # rubocop:disable Lint/NestedMethodDefinition
          Component.new(document)
        end
      end
    end
  end

  def initialize(attrs)
    super(**attrs.symbolize_keys)
  end
end
