# frozen_string_literal: true

module DocTemplate
  module Tags
    class HeadingTag < BaseTag
      TEMPLATE = 'heading.html.erb'

      def parse(node, opts = {})
        # we have to collect all the next siblings until next stop-tag
        params = {
          content: parse_nested(content_until_break(node), opts),
          heading: "<h3>#{heading(opts[:value])}</h3>",
          tag: self.class::TAG_NAME
        }
        @content = parse_template params, TEMPLATE

        replace_tag node
        self
      end

      private

      def prefix
        self.class::TITLE_PREFIX
      end

      def heading(value)
        value.include?(prefix + ':') ? value : "#{prefix}: #{value}"
      end
    end

    class RubricTag < HeadingTag
      TAG_NAME = 'rubric'
      TITLE_PREFIX = 'Rubric'
    end

    class JsTag < HeadingTag
      TAG_NAME = 'js'
      TITLE_PREFIX = 'Juicy Sentences'
    end

    class EtTag < HeadingTag
      TAG_NAME = 'et'
      TITLE_PREFIX = 'Exit Ticket'
    end

    class PhotoTag < HeadingTag
      TAG_NAME = 'photo'
      TITLE_PREFIX = 'Photograph'
    end

    class AssessTag < HeadingTag
      TAG_NAME = 'assess'
      TITLE_PREFIX = 'Assessment'
    end

    class ShTag < HeadingTag
      TAG_NAME = 'sh'

      def heading(value)
        value
      end
    end

    class KeyTag < HeadingTag
      TAG_NAME = 'key'

      def heading(value)
        "#{value}<br/>(For Teacher Reference)"
      end
    end

    class ThTag < HeadingTag
      TAG_NAME = 'th'

      def heading(value)
        "#{value}<br/>(For Teacher Reference)"
      end
    end
  end

  Template.register_tag(Tags::RubricTag::TAG_NAME, Tags::RubricTag)
  Template.register_tag(Tags::JsTag::TAG_NAME, Tags::JsTag)
  Template.register_tag(Tags::EtTag::TAG_NAME, Tags::EtTag)
  Template.register_tag(Tags::PhotoTag::TAG_NAME, Tags::PhotoTag)
  Template.register_tag(Tags::AssessTag::TAG_NAME, Tags::AssessTag)
  Template.register_tag(Tags::ShTag::TAG_NAME, Tags::ShTag)
  Template.register_tag(Tags::KeyTag::TAG_NAME, Tags::KeyTag)
  Template.register_tag(Tags::ThTag::TAG_NAME, Tags::ThTag)
end
