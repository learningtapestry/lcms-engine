# frozen_string_literal: true

module DocTemplate
  module Tags
    class ImageTag < TableTag
      TAG_NAME = 'image'
      TEMPLATES = { default: 'image.html.erb',
                    gdoc: 'gdoc/image.html.erb' }.freeze

      def parse_table(table)
        params = {
          caption: table.at_xpath('.//tr[2]/td').text,
          image_src:,
          subject: @opts[:metadata].try(:[], 'subject')
        }
        @content = parse_template(params, template_name(@opts))
        replace_tag table
      end

      private

      def image_src
        filename = "#{@opts[:value]}.jpg"
        grade = @opts[:metadata]['grade']
        unit = @opts[:metadata]['unit']
        "https://unbounded-uploads-development.s3.amazonaws.com/ela-images/G#{grade}/#{unit}/#{filename}"
      end
    end
  end

  Template.register_tag(Tags::ImageTag::TAG_NAME, Tags::ImageTag)
end
