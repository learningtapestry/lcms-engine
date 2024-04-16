# frozen_string_literal: true

module DocTemplate
  module Tags
    CONFIG_PATH = Rails.root.join('config', 'tags.yml')
    RE_BOLD = /(\[b\]([^\[]*)\[b:end\])/i
    RE_ITALIC = /(\[i\]([^\[]*)\[i:end\])/i
    RE_LINE_BREAK = /\[line-break\]/i
    TAG_LINE_BREAK = '<br/><br/>'

    mattr_accessor :config

    self.config = YAML.load_file(Tags::CONFIG_PATH, aliases: true) || {}

    # By default we remove unknown tags (`DefaultTag`)
    config['default'] ||= { 'remove' => true }

    #
    # Substitutes the following custom tags with plain HTML markup:
    #
    #  # [b]Text[b:end] -> <b>Text</b>
    #  # [i]Text[i:end] -> <i>Text</i>
    #  # [line-break] -> <br/><br/>
    #
    # @param [String] content Content to substitute vars in
    # @return [String]
    def self.substitute_tags_in(content)
      return '' if content.blank?

      # @type var content: String
      content
        .gsub("\n", '<br/>')
        .gsub(RE_LINE_BREAK, TAG_LINE_BREAK)
        .gsub(RE_ITALIC, '<i>\2</i>')
        .gsub(RE_BOLD, '<b>\2</b>')
    end
  end
end
