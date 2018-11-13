# frozen_string_literal: true

module DocumentDownloader
  class PDF < DocumentDownloader::Base
    MIME_TYPE = 'application/pdf'

    def self.gdoc_file_url(id)
      "https://docs.google.com/file/d/#{id}"
    end

    def pdf_content
      service.get_file(file_id, download_dest: StringIO.new).string
    end
  end
end
