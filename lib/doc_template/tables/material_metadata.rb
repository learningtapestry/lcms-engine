# frozen_string_literal: true

module DocTemplate
  module Tables
    class MaterialMetadata < Base
      CONFIG_PATH = Rails.root.join('config', 'materials_rules.yml')
      HEADER_LABEL = 'material-metadata'
      HTML_VALUE_FIELDS = [].freeze

      def parse(fragment, _template_type)
        super
        if @data['sheet-type'].blank?
          @data['type'] ||= 'default'
          @data['sheet-type'] = config[@data['type']]
        end
        self
      end

      private

      def config
        @config ||= YAML.load_file(CONFIG_PATH)['sheet_types']
      end
    end
  end
end
