# frozen_string_literal: true

class ResourceDownload < Lcms::Engine::ApplicationRecord
  DOWNLOAD_PER_CATEGORY_LIMIT = 5

  belongs_to :resource
  belongs_to :download
  belongs_to :download_category

  validates :download, presence: true

  accepts_nested_attributes_for :download
end
