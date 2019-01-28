# frozen_string_literal: true

module ActionView
  module Helpers
    module FormTagHelper
      alias orig_form_tag form_tag
      def form_tag(url_for_options = {}, options = {}, &block)
        options[:enforce_utf8] = false
        orig_form_tag(url_for_options, options, &block)
      end
    end
  end
end

ActionView::Base.field_error_proc = proc do |html_tag, _|
  html_tag.html_safe
end
