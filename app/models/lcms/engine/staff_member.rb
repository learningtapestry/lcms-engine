# frozen_string_literal: true

module Lcms
  module Engine
    class StaffMember < ApplicationRecord
      validates :first_name, :last_name, presence: true
      validates :bio, length: { maximum: 4096 }
      enum :staff_type, { staff: 1, board: 2 }

      scope :order_by_name, -> { order(:last_name) }
      scope :order_by_name_with_precedence, -> { order(:order, :last_name) }

      def name
        "#{first_name} #{last_name}"
      end

      # mount_uploader :image_file, StaffImageUploader
    end
  end
end
