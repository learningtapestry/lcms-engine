# frozen_string_literal: true

module Lcms
  module Engine
    class StandardForm < ImportForm
      def save
        super { StandardsImportService.call link }
      end
    end
  end
end
