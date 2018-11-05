# frozen_string_literal: true

class MaterialPresenter < ContentPresenter
  attr_accessor :lesson
  attr_reader :parsed_document

  delegate :css_styles, :short_url, :subject, to: :lesson
  delegate :sheet_type, to: :metadata
  delegate :parts, to: :parsed_document

  DEFAULT_TITLE = 'Material'

  def anchors
    @anchors || []
  end

  def base_filename(with_version: true)
    name = identifier
    unless name =~ /^(math|ela)/i || pdf?
      name = "#{lesson.short_breadcrumb(join_with: '_', with_short_lesson: true)}_#{name}"
    end
    with_version ? "#{name}_v#{version.presence || 1}" : name
  end

  def identifier
    metadata['identifier']
  end

  def cc_attribution
    metadata['cc_attribution'].presence || lesson&.cc_attribution
  end

  def content_for(context_type)
    layout(context_type)&.content
  end

  def content_type
    metadata['type']
  end

  def full_breadcrumb
    lesson.full_breadcrumb(unit_level: unit_level?)
  end

  def gdoc_folder
    "#{lesson.id}_v#{lesson.version}"
  end

  def gdoc_preview_title
    preview_links['gdoc'].present? ? 'Preview Google Document' : 'Generate Google Document'
  end

  def gdoc_url
    material_url('gdoc')
  end

  def header?
    config[:header]
  end

  def header_breadcrumb
    short_breadcrumb = lesson.short_breadcrumb(join_with: '/', unit_level: unit_level?,
                                               with_short_lesson: true, with_subject: false)
    short_title = unit_level? ? lesson.resource&.parent&.title : lesson.title
    "#{lesson.subject.upcase} #{short_breadcrumb} #{short_title}"
  end

  def name_date?
    # toggle display of name-date row on the header
    # https://github.com/learningtapestry/unbounded/issues/422
    # Added the config definition for new types. If config says "NO", it's impossible to force-add the name-date field.
    # It's impossible only to remove it when config allows it
    !metadata['name_date'].to_s.casecmp('no').zero? && config[:name_date]
  end

  def material_filename
    "materials/#{id}/#{base_filename}"
  end

  def orientation
    metadata['orientation'].presence || super
  end

  def pdf_filename
    "#{lesson.id}/#{base_filename}"
  end

  def pdf_url
    material_url('url')
  end

  def pdf_preview_title
    preview_links['pdf'].present? ? 'Preview PDF' : 'Generate PDF'
  end

  def preserve_table_padding?
    (metadata['preserve_table_padding'].presence || 'no').casecmp('yes').zero?
  end

  def render_content(context_type, options = {})
    options[:parts_index] = document_parts_index
    DocumentRenderer::Part.call(layout_content(context_type), options)
  end

  def show_title?
    (metadata['show_title'].presence || 'yes').casecmp('yes').zero?
  end

  def student_material?
    ::Material.where(id: id).gdoc.where_metadata_any_of(materials_config_for(:student)).exists?
  end

  def subtitle
    config.dig(:subtitle, sheet_type.to_sym).presence || DEFAULT_TITLE
  end

  def teacher_material?
    ::Material.where(id: id).gdoc.where_metadata_any_of(materials_config_for(:teacher)).exists?
  end

  def title
    metadata['title'].presence || config[:title].presence || DEFAULT_TITLE
  end

  def thumb_url
    material_url('thumb')
  end

  def unit_level?
    metadata['breadcrumb_level'] == 'unit'
  end

  def vertical_text?
    metadata['vertical_text'].present?
  end

  private

  def document_parts_index
    @document_parts_index ||= parts.map { |p| [p[:placeholder], { anchor: p[:anchor], content: p[:content] }] }.to_h
  end

  def layout_content(context_type)
    parts.find { |p| p[:part_type] == :layout && p[:context_type] == context_type }&.dig(:content) || ''
  end

  def material_links
    @material_links ||= lesson.links['materials']&.dig(id.to_s)
  end

  def material_url(key)
    material_links&.dig(key).presence || ''
  end
end
