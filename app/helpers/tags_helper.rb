# frozen_string_literal: true

module TagsHelper
  TAG_GROUPS = {
    ccss_standards: 'CCSS Standard',
    ccss_domain: 'CCSS Domain',
    ccss_cluster: 'CCSS Cluster',
    texts: 'Texts',
    authors: 'Authors'
  }.freeze

  def render_tag_clouds(resource)
    named_tags = resource.filtered_named_tags
    render partial: 'resources/tags',
           locals: { tag_clouds: tag_clouds(named_tags), color_code: color_code(resource) }
  end

  def tag_clouds(named_tags)
    named_tags[:ell_appropriate] = named_tags[:ell_appropriate] ? 'ELL Appropriate' : nil
    named_tags.transform_values { |v| Array.wrap(v).flatten.compact.uniq.sort }
  end

  def each_tags_cloud!(tag_clouds)
    tags = tag_clouds.keep_if { |k, v| TAG_GROUPS.key?(k) && v.present? }
    tags.each { |k, v| yield(v, TAG_GROUPS[k]) }
    yield([], nil) if tags.empty?
  end
end
