# frozen_string_literal: true

class StandardLink < Lcms::Engine::ApplicationRecord
  belongs_to :standard_begin, class_name: 'Standard', foreign_key: 'standard_begin_id'
  belongs_to :standard_end, class_name: 'Standard', foreign_key: 'standard_end_id'
end
