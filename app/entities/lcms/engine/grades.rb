# frozen_string_literal: true

module Lcms
  module Engine
    # Value object for abstracting Grades info from the Resource Model
    class Grades
      GRADES = ['prekindergarten', 'kindergarten', 'grade 1', 'grade 2', 'grade 3',
                'grade 4', 'grade 5', 'grade 6', 'grade 7', 'grade 8', 'grade 9',
                'grade 10', 'grade 11', 'grade 12'].freeze

      GRADES_ABBR = %w(pk k 1 2 3 4 5 6 7 8 9 10 11 12).freeze

      attr_reader :model

      class << self
        def grades
          ::Lcms::Engine::Grades::GRADES
        end

        def grades_abbrevs
          ::Lcms::Engine::Grades::GRADES_ABBR
        end
      end

      def initialize(model)
        @model = model
      end

      def list
        @list ||= case model
                  when Resource
                    Array.wrap model.metadata['grade']
                  when Search::Document
                    Array.wrap model.grade.presence
                  else
                    model.grade_list
                  end.sort_by { |g| self.class.grades.index(g) }
      end

      def average(abbr: true)
        return nil if average_number.nil?

        avg = self.class.grades[average_number]
        abbr ? (grade_abbr(avg) || 'base') : avg
      end

      def average_number
        return nil if list.empty?

        list.map { |g| self.class.grades.index(g) }.sum / (list.size.nonzero? || 1)
      end

      def grade_abbr(abbr)
        grade = abbr.downcase
        return 'k' if grade == 'kindergarten'
        return 'pk' if grade == 'prekindergarten'

        grade[/\d+/]
      end

      def to_str
        return '' unless list.any?

        "Grade #{range}"
      end

      def range
        groups = [] # hold each groups of subsequent grades chain
        chain = [] # current chain of grades
        prev = nil # previous grade

        list.each_with_index do |g, idx|
          abbr = grade_abbr(g).upcase

          # if the current grade is subsequent we store on the same chain
          if idx.zero? || self.class.grades.index(g) == self.class.grades.index(prev) + 1
            chain << abbr
          else
            # the grade is not subsequent, so we store the current chain, and create a new one
            groups << chain.dup unless chain.empty?
            chain = [abbr]
          end
          prev = g
        end
        groups << chain.dup unless chain.empty?

        # finally we grab only the first and last from each chain to make the range pairs
        groups.map { |c| c.size < 2 ? c.first : "#{c.first}-#{c.last}" }.join(', ')
      end
    end
  end
end
