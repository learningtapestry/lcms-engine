# frozen_string_literal: true

module Lcms
  module Engine
    class LessonsPdfBundler
      attr_reader :unit

      PDF_LINKS_KEYS = {
        full: 'pdf',
        tm: 'pdf_tm',
        sm: 'pdf_sm'
      }.freeze

      # tmp folder for downloaded pdfs and bundled zip
      TMP_FOLDER = Rails.root.join('tmp', 'unbounded-pdfs')

      def initialize(unit, type = :full)
        @unit = unit
        @type = type.to_sym
      end

      def bundle
        return if files.empty?

        folder = File.join(TMP_FOLDER, dirname)
        begin
          FileUtils.mkdir_p folder # ensure the folder exists

          files.each do |url|
            fname = filename url
            download url, File.join(folder, fname)
          end

          zip_files
        ensure
          FileUtils.rm_r(folder) if File.exist?(folder) # remove tmp pdfs
        end

        # return ziped bundle path
        "#{folder}.zip"
      end

      private

      def dirname
        @dirname ||= Breadcrumbs.new(unit).pieces.map(&:parameterize).push(@type.to_s).join('_')
      end

      def documents
        @documents ||= unit.children.map(&:document).compact
      end

      def download(url, path)
        # Reads and writes in chunks, and thus does not read the whole file in memory
        File.open(path, 'w') do |f|
          IO.copy_stream(URI.parse(url).open, f)
        end
      end

      def filename(uri)
        URI(uri).path.split('/').last
      end

      def files
        key = PDF_LINKS_KEYS[@type]
        documents.map { |d| d.links[key] }.compact
      end

      def zip_files
        `cd #{TMP_FOLDER} && zip -r #{dirname} #{dirname}/*.pdf`
      end
    end
  end
end
