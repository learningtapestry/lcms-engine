# frozen_string_literal: true

#
# Exporter in LTI Thin Common Cartridge format
#
module Lti
  class ThinCommonCartridge
    attr_reader :links

    def initialize(items)
      @items = Array.wrap items
      @xml = File.open(File.expand_path MANIFEST_FILEPATH) { |f| Nokogiri::XML(f) }
      @link_template = File.open(File.expand_path LTI_LINK_FILEPATH) { |f| Nokogiri::XML(f) }
      @links = []

      create_nodes
    end

    def create_nodes
      # Build hierarchy of objects
      root_item = xml.at 'organizations/organization/item'
      items.each { |c| add_item c, root_item }
    end

    def manifest
      xml.to_xml
    end

    private

    LTI_LINK_RESOURCE_TYPE = 'imsbasiclti_xmlv1p0'
    MANIFEST_FILEPATH = Rails.root.join 'lib', 'lti', 'xml', 'imsmanifest.xml'
    LTI_LINK_FILEPATH = Rails.root.join 'lib', 'lti', 'xml', 'lti_link.xml'

    attr_reader :items, :link_template, :xml

    def add_item(item, parent)
      item[:identifier] = "ub#{SecureRandom.hex(17)}"
      item[:identifierref] = "#{item[:identifier]}_link"

      params = {
        identifier: item[:identifier],
        identifierref: (item[:identifierref] if item[:url].present?)
      }
      node = create_node 'item', params
      node.add_child %(<title>#{item[:title].capitalize}</title>)
      parent.add_child node

      item[:children].each { |c| add_item c, node }

      add_resource(item) if item[:url].present?

      node
    end

    def add_resource(item)
      params = {
        identifier: item[:identifierref],
        type: LTI_LINK_RESOURCE_TYPE
      }
      node = create_node('resource', params)
      resources_node.add_child node

      href = "lti_links/#{item[:identifierref]}.xml"
      create_link item, href

      file_node = create_node 'file', href: href
      node.add_child file_node
    end

    def create_link(item, file_href)
      @link_template.at('//blti:launch_url').content = item[:url]
      links << {
        name: file_href,
        data: @link_template.to_xml
      }
    end

    def create_node(name, attrs = {})
      node = Nokogiri::XML::Node.new name, xml
      attrs.compact.each { |k, v| node[k.to_s] = v }
      node
    end

    def resources_node
      @resources_node ||=
        begin
          if (node = @xml.at 'resources').nil?
            node = create_node 'resources'
            xml.root.add_child node
          end
          node
        end
    end
  end
end
