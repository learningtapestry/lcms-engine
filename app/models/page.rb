# frozen_string_literal: true

class Page < Lcms::Engine::ApplicationRecord
  validates :body, :title, :slug, presence: true

  def full_title
    "UnboundEd - #{title}"
  end
end
