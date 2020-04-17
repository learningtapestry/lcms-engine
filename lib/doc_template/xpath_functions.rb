# frozen_string_literal: true

module DocTemplate
  class XpathFunctions
    def case_insensitive_equals(node_set, str_to_match)
      return node_set.to_s.squish.casecmp(str_to_match).zero? if node_set.is_a?(String)

      node_set.find_all { |node| node.to_s.squish.casecmp(str_to_match).zero? }
    end

    def case_insensitive_contains(node_set, str_to_match)
      node_set.find_all { |node| node.to_s.downcase.include?(str_to_match.to_s.downcase) }
    end

    def case_regular(node_set, re_to_match)
      node_set.to_s.match?(Regexp.new(re_to_match, true)) ? node_set : []
    end
  end
end
