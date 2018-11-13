# frozen_string_literal: true

module DocTemplate
  module Objects
    class BaseMetadata
      include Virtus.model

      attribute :cc_attribution, String, default: ''
      attribute :description, String, default: ''
      attribute :grade, String, default: ''
      attribute :lesson, String, default: ''
      attribute :lesson_mathematical_practice, String, default: ''
      attribute :lesson_objective, String, default: ''
      attribute :lesson_standard, String, default: ''
      attribute :materials, String, default: ''
      attribute :module, String, default: ''
      attribute :preparation, String, default: ''
      attribute :resource_subject, String, default: ->(m, _) { m.subject.try(:downcase) }
      attribute :standard, String, default: ''
      attribute :subject, String, default: ''
      attribute :teaser, String, default: ''
      attribute :title, String, default: ''
      attribute :topic, String, default: ''
      attribute :type, String, default: 'core'
      attribute :unit, String, default: ''

      def self.build_from(data)
        copy = data&.transform_keys { |k| k.to_s.underscore }
        new(copy.presence || {})
      end
    end
  end
end
