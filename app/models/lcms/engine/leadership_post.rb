# frozen_string_literal: true

module Lcms
  module Engine
    class LeadershipPost < ActiveRecord::Base
      validates :first_name, :last_name, presence: true
      validates :description, length: { maximum: 4096 }

      scope :order_by_name_with_precedence, -> { order(:order, :last_name) }

      def name
        "#{first_name} #{last_name}"
      end
    end
  end
end
