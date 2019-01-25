# frozen_string_literal: true

module Lcms
  module Engine
    module HeapNotifyable
      extend ActiveSupport::Concern

      private

      def heap_notify(event)
        return if Heap.app_id.blank?
        return if current_user.nil?

        props = {
          access_code: current_user.access_code,
          email: current_user.email
        }.compact
        Heap.track event, current_user.id, props
      end
    end
  end
end
