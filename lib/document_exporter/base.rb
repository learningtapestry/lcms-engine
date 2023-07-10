# frozen_string_literal: true

module DocumentExporter
  class Base
    def self.pdf_key(type)
      type == 'full' ? 'pdf' : "pdf_#{type}"
    end

    def initialize(document, options = {})
      @document = document
      @options = options
    end

    def export
      raise NotImplementedError
    end

    #
    # Take into consideration that in one component materilas are uniq. So
    # just the first occurence of exluded material is removed
    #
    def included_materials(context_type: :default)
      parts = context_type == :default ? @document.document_parts.default : @document.document_parts.gdoc

      @included_materials ||= [].tap do |result|
        # Take non optional materials ONLY
        result.concat parts.general.pluck(:materials).flatten.compact

        @options[:excludes]&.each do |x|
          next unless (part = parts.find_by anchor: x)

          # if it's optional activity - add it
          # otherwise - delete it from result
          part.materials.compact.each do |id|
            part.optional? ? result.push(id) : result.delete_at(result.index(id))
          end
        end
      end.map(&:to_i)
    end

    def ordered_materials(material_ids)
      @document.ordered_material_ids & material_ids
    end

    private

    def base_path(name)
      File.join('documents', 'pdf', name)
    end

    def render_template(path, layout:)
      field = path.starts_with?('/') ? :file : :template
      Lcms::Engine::ApplicationController.render(
        field => path,
        layout:,
        assigns: { document: @document, options: @options }
      )
    end

    def template_path(name)
      base_path(name)
    end
  end
end
