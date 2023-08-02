# frozen_string_literal: true

module DocTemplate
  module Tags
    class PageBreakTag < BaseTag
      CSS_CLASS = 'u-pdf-alwaysbreak'
      TAG_NAME = /page(-|\s*)break/
      TAG_SUB = '<p>--GDOC-PAGE-BREAK--</p>'

      def parse(node, opts)
        @opts = opts
        check_tag_soft_return(node)
        @content = if gdoc?(opts)
                     TAG_SUB
                   else
                     %(<div class="#{CSS_CLASS} do-not-strip"></div>)
                   end
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::PageBreakTag::TAG_NAME, Tags::PageBreakTag)
end
