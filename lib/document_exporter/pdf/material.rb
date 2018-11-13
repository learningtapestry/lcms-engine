# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Material < PDF::Base
      private

      def template_path(name)
        File.join('documents', 'pdf', 'materials', name)
      end
    end
  end
end
