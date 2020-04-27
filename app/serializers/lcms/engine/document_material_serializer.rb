# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentMaterialSerializer < ActiveModel::Serializer
      attributes :data

      def initialize(document, materials)
        super(document)
        @document = document
        @materials = materials
      end

      def data
        ordered_ids = @document.ordered_material_ids
        anchors = @document.materials_anchors
        @materials
          .sort_by { |m| ordered_ids.index(m.id) }
          .map do |material|
          MaterialSerializer.new(
            DocumentGenerator.material_presenter.new material, document: @document, anchors: anchors[material.id] || []
          ).as_json
        end
      end
    end
  end
end
