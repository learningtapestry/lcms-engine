# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceDownload < ActiveRecord::Base
      DOWNLOAD_PER_CATEGORY_LIMIT = 5

      belongs_to :resource
      belongs_to :download
      belongs_to :download_category

      validates :download, presence: true

      accepts_nested_attributes_for :download
    end
  end
end
