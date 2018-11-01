# frozen_string_literal: true

class RomanNumerals
  ROMAN_NUMERALS_RE = /^(M|CM|D|CD|C|XC|L|XL|X|IX|V|IV|I)/
  SYMBOLS = [
    [1000, 'M'],
    [900, 'CM'],
    [500, 'D'],
    [400, 'CD'],
    [100, 'C'],
    [90, 'XC'],
    [50, 'L'],
    [40, 'XL'],
    [10, 'X'],
    [9, 'IX'],
    [5, 'V'],
    [4, 'IV'],
    [1, 'I']
  ].freeze

  def self.to_roman(num)
    [].tap do |roman|
      SYMBOLS.each do |arab, rom|
        while num >= arab
          roman << rom
          num -= arab
        end
      end
    end.join('')
  end

  def self.from_roman(roman)
    value = 0
    str = roman.upcase

    while (m = str.match(ROMAN_NUMERALS_RE))
      # add the arabic number for the matched numeral
      value += SYMBOLS.detect { |pair| pair[1] == m[1] }.first
      str = m.post_match
    end

    value
  end
end
