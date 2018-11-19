# frozen_string_literal: true

module DocTemplate
  CONFIG_PATH ||= Rails.root.join('config', 'lcms.yml')

  DEFAULTS ||= {
    bundles: { unit: '::BundleGenerator' },
    context_types: %w(default gdoc),
    lesson_contexts: %w(gdoc pdf),
    materials_contexts: %w(gdoc pdf),
    metadata: {
      context: 'Lt::Lcms::Metadata::Context',
      service: 'Lt::Lcms::Metadata::Service'
    },
    sanitizer: '::HtmlSanitizer'
  }.freeze

  FULL_TAG ||= /\[([^\]:\s]*)?\s*:?\s*([^\]]*?)?\]/mo
  START_TAG ||= '\[[^\]]*'

  STARTTAG_XPATH ||= 'span[contains(., "[")]'
  ENDTAG_XPATH ||= 'span[contains(., "]")]'

  mattr_accessor :config

  self.config = YAML.load_file(CONFIG_PATH) || {}

  config['bundles'] ||= DEFAULTS[:bundles]

  config['metadata'] ||= {}
  config['metadata']['context'] ||= DEFAULTS[:metadata][:context]
  config['metadata']['service'] ||= DEFAULTS[:metadata][:service]

  config['sanitizer'] ||= DEFAULTS[:sanitizer]

  class << self
    def context_types
      @context_types ||= Array.wrap(config['contexts']).presence || DEFAULTS[:context_types]
    end

    def document_contexts
      @document_contexts ||= Array.wrap(config['document_contexts']).presence || DEFAULTS[:lesson_contexts]
    end

    def material_contexts
      @material_contexts ||= Array.wrap(config['material_contexts']).presence || DEFAULTS[:materials_contexts]
    end

    def sanitizer
      @sanitizer ||= config['sanitizer'].constantize
    end
  end
end

require_dependency 'doc_template/template'
require_dependency 'doc_template/document'
require_dependency 'doc_template/tags'
require_dependency 'doc_template/document_toc'
require_dependency 'doc_template/xpath_functions'

Dir["#{__dir__}/doc_template/tables/*.rb"].each(&method(:require_dependency))
Dir["#{__dir__}/doc_template/tags/*.rb"].each(&method(:require_dependency))
Dir["#{__dir__}/doc_template/objects/*.rb"].each(&method(:require_dependency))
