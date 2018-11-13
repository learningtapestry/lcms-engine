# frozen_string_literal: true

#
# Makes an image from the text given
#
class TextToImage
  DEFAULT_OPTS = {
    format: 'png',
    height: '',
    width: 600
  }.freeze

  def initialize(text, options = {})
    @text = text
    @options = DEFAULT_OPTS.merge options
  end

  def raw
    data
  end

  private

  attr_accessor :options, :text

  def data
    MiniMagick::Tool::Convert.new do |img|
      img.size size
      img.caption text
      img.rotate(options[:rotate]) if options[:rotate].present?
      img << "#{options[:format]}:-"
    end
  end

  def size
    [options[:width].to_s, options[:height].to_s].join('x')
  end
end
