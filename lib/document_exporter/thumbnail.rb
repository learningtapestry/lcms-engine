# frozen_string_literal: true

module DocumentExporter
  class Thumbnail
    THUMBNAIL_RATIO = 1.25

    def initialize(content)
      @content = content
    end

    def export
      pdf = MiniMagick::Image.read(@content)
      @width = pdf.pages[0][:width] / THUMBNAIL_RATIO
      @height = pdf.pages[0][:height] / THUMBNAIL_RATIO
      pdf.format('jpg', 0, density: 300, background: '#fff', alpha: 'remove', resize: "#{@width}x#{@height}").to_blob
    end

    def orientation
      @width < @height ? 'portrait' : 'landscape'
    end
  end
end
