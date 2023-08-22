# frozen_string_literal: true

module DocTemplate
  module Objects
    class MaterialMetadata
      include Virtus::InstanceMethods::Constructor
      include Virtus.model
      KEY_PARAMS = %w(breadcrumb_level sheet_type type).freeze

      attribute :activity, Integer
      attribute :breadcrumb_level, String, default: 'lesson'
      attribute :cc_attribution, String, default: ''
      attribute :grade, Integer
      attribute :guidebook, String
      attribute :header_footer, String, default: 'yes'
      attribute :identifier, String, default: ''
      attribute :lesson, Integer
      attribute :name_date, String, default: 'no'
      attribute :orientation, String
      attribute :pdf_url, String
      attribute :preserve_table_padding, String, default: 'no'
      attribute :section, Integer
      attribute :sheet_type, String, default: ''
      attribute :show_title, String, default: 'yes'
      attribute :subject, String, default: ''
      attribute :title, String, default: ''
      attribute :thumb_url, String
      attribute :type, String, default: 'default'
      attribute :vertical_text, String

      class << self
        def build_from(data)
          materials_data = data.transform_keys { |k| k.to_s.underscore }
                             .delete_if { |_, v| v&.strip.blank? }
          KEY_PARAMS.each do |k|
            materials_data[k] = materials_data[k].to_s.downcase if materials_data.key?(k)
          end

          new(materials_data)
        end

        def build_from_pdf(identifier:, title:)
          new(identifier:, sheet_type: 'pdf', title:, type: 'pdf')
        end

        def dump(data)
          data.as_json
        end

        def load(data)
          new(data)
        end
      end
    end
  end
end
