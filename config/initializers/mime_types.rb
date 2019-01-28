# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
Mime::Type.register('image/svg+xml', :svg) unless Mime.const_defined?(:SVG)
Mime::Type.register('image/x-icon', :ico) unless Mime.const_defined?(:ICO)
