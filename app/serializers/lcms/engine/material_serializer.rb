# frozen_string_literal: true

module Lcms
  module Engine
    class MaterialSerializer < ActiveModel::Serializer
      attributes :anchors, :id, :identifier, :gdoc_url, :orientation, :pdf_url, :source_type, :subtitle, :title,
                 :thumb_url, :pdf?
      delegate :anchors, :gdoc_url, :lesson, :orientation, :pdf_url, :source_type, :subtitle, :title,
               :thumb_url, to: :object

      def pdf?
        object.metadata['type'].casecmp('pdf').zero?
      end
    end
  end
end
