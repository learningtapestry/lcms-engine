# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Material < PDF::Base
      private

      def template_path(name)
        custom_template_for(name).presence || File.join('lcms', 'engine', 'documents', 'pdf', 'materials', name)
      end
    end
  end
end
