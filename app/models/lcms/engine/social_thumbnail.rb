# frozen_string_literal: true

module Lcms
  module Engine
    class SocialThumbnail < ActiveRecord::Base
      MEDIAS = %w(all facebook pinterest twitter).freeze

      mount_uploader :image, SocialThumbnailUploader

      belongs_to :target, polymorphic: true

      validates :target, :media, presence: true
      validates :media, inclusion: { in: MEDIAS }
    end
  end
end
