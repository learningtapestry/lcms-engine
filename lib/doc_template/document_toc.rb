# frozen_string_literal: true

module DocTemplate
  class DocumentToc
    REGISTERED_METADATA = %i(agenda sections).freeze
    private_constant :REGISTERED_METADATA

    #
    # Build the ToC from the first available metadata.
    # We're doing that to allow cross-subject data passing.
    #
    def self.parse(opts = {})
      metadata = REGISTERED_METADATA.detect { |m| opts[m]&.children.present? }
      Objects::TocMetadata.new opts[metadata]
    end
  end
end
