# frozen_string_literal: true

module Lcms
  module Engine
    class StandardLink < ApplicationRecord
      belongs_to :standard_begin, class_name: 'Standard', foreign_key: 'standard_begin_id'
      belongs_to :standard_end, class_name: 'Standard', foreign_key: 'standard_end_id'
    end
  end
end
