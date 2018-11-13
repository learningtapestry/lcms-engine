# frozen_string_literal: true

module DocTemplate
  module Tags
    CONFIG_PATH = Rails.root.join('config', 'tags.yml')

    mattr_accessor :config

    self.config = YAML.load_file(Tags::CONFIG_PATH) || {}

    # By default we remove unknown tags (`DefaultTag`)
    config['default'] ||= { 'remove' => true }
  end
end
