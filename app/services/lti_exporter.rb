# frozen_string_literal: true

require 'zip'

class LtiExporter
  class << self
    include Rails.application.routes.url_helpers

    def perform(resource)
      cartridge = create_cartridge resource

      files = [{ name: 'imsmanifest.xml', data: cartridge.manifest }]
      files.concat cartridge.links
      create_zip_stream(files).read
    end

    private

    def build_items(resource)
      resource.children.map do |c|
        {
          children: build_items(c),
          title: c.title,
          url: (lti_document_url(c.document.id, protocol: :https) if c.lesson? && c.document.present?)
        }
      end
    end

    def create_cartridge(resource)
      # Note: For now work only with Modules
      # Subject - Grade - Module
      parent = {
        children: [{
          children: [{
            children: build_items(resource),
            identifier: SecureRandom.hex(17),
            title: resource.title
          }],
          title: resource.metadata['grade']
        }],
        title: resource.metadata['subject']
      }

      Lti::ThinCommonCartridge.new parent
    end

    def create_zip_stream(files)
      zip = Zip::OutputStream.write_buffer do |z|
        files.each do |f|
          z.put_next_entry f[:name]
          z.write f[:data]
        end
      end
      zip.rewind
      zip
    end
  end
end
