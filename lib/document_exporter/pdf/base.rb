# frozen_string_literal: true

module DocumentExporter
  module Pdf
    class Base < DocumentExporter::Base
      def self.s3_folder
        @s3_folder ||= ENV.fetch('SWAP_DOCS', 'documents')
      end

      def export
        WickedPdf.new.pdf_from_string(pdf_content, pdf_params)
      end

      def pdf_content
        content = render_template template_path('show'), layout: 'lcms/engine/pdf'
        content.gsub(/(___+)/, '<span class="o-od-compress-underscore">\1</span>')
      end

      protected

      def combine_pdf_for(pdf, material_ids)
        material_ids.each do |id|
          next unless (url = @document.links['materials']&.dig(id.to_s, 'url'))

          pdf << CombinePDF.parse(Net::HTTP.get(URI.parse(url)))
        end
        pdf
      end

      private

      TEMPLATE_EXTS = %w(erb html.erb).freeze
      private_constant :TEMPLATE_EXTS

      def base_path(name)
        custom_template_for(name).presence || File.join('lcms', 'engine', 'documents', 'pdf', name)
      end

      def custom_template_for(name)
        result = ''
        Array
          .wrap(DocTemplate::Tags.config['pdf_templates_path'])
          .each do |path|
          file = TEMPLATE_EXTS
                   .map { |ext| File.join path, "#{name}.#{ext}" }
                   .detect { |f| File.exist? f }
          break if (result = file).present?
        end
        result
      end

      def pdf_custom_params
        @document.config.slice(:margin, :dpi)
      end

      def pdf_params
        {
          disable_internal_links: false,
          disable_external_links: false,
          disable_smart_shrinking: true,
          disposition: 'attachment',
          footer: {
            content: render_template(base_path('_footer'), layout: 'lcms/engine/pdf_plain'),
            line: false,
            spacing: 2
          },
          javascript_delay: 500,
          orientation: @document.orientation,
          outline: { outline_depth: 3 },
          page_size: 'Letter',
          print_media_type: false
        }.merge(pdf_custom_params)
      end
    end
  end
end
