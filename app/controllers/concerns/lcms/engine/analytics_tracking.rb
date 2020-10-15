# frozen_string_literal: true

require 'staccato/adapter/logger'

module Lcms
  module Engine
    module AnalyticsTracking
      extend ActiveSupport::Concern

      GA_DEBUG_MODE = false

      included do
        private

        def ga_client_id
          # Last two char sequences, separated by a dot char ".":
          @ga_client_id ||= cookies['_ga'].split('.').last(2).join('.') if cookies['_ga'].present?
        end

        def ga_id
          @ga_id ||= ENV['GOOGLE_ANALYTICS_ID']
        end

        def ga_tracker(options: {})
          # @see options in Staccato::Hit::GLOBAL_OPTIONS
          Staccato.tracker(ga_id, ga_client_id, options) do |c|
            if GA_DEBUG_MODE
              c.adapter = Staccato::Adapter::Logger.new(
                Staccato.ga_collection_uri,
                Logger.new($stdout),
                ->(params) { JSON.dump(params) }
              )
            end
          end
        end

        def ga_track_download(action:, label:, category: nil)
          return if ga_client_id.blank?
          return if googlebot?(ua: request.user_agent)

          category ||= 'download'
          ga_tracker.event(category: category, action: action, label: label)
        end

        def googlebot?(ua:)
          ua.to_s.downcase.include?('googlebot')
        end
      end
    end
  end
end
