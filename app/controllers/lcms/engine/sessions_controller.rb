# frozen_string_literal: true

module Lcms
  module Engine
    class SessionsController < Devise::SessionsController
      include HeapNotifyable

      def create
        super
        heap_notify 'Login'
      end

      def destroy
        heap_notify 'Logout'
        super
      end
    end
  end
end
