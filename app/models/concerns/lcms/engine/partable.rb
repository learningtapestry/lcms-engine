# frozen_string_literal: true

module Lcms
  module Engine
    module Partable
      def create_parts_for(template)
        template.parts.each do |part|
          document_parts.create!(
            active: true,
            anchor: part[:anchor],
            content: part[:content],
            context_type: part[:context_type],
            data: part[:data],
            materials: part[:materials],
            optional: part[:optional],
            part_type: part[:part_type],
            placeholder: part[:placeholder]
          )
        end
      end

      def layout(context_type)
        document_parts.where(part_type: :layout, context_type: DocumentPart.context_types[context_type.to_sym]).last
      end
    end
  end
end
