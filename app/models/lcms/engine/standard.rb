# frozen_string_literal: true

module Lcms
  module Engine
    class Standard < ApplicationRecord
      # NOTE: #954 - to be removed?
      ALT_NAME_REGEX = {
        'ela' => /^[[:alpha:]]+\.(k|pk|\d+)\.\d+(\.[[:alnum:]]+)?$/,
        'math' => /^(k|pk|\d+)\.[[:alpha:]]+(\.[[:alpha:]]+)?\.\d+(\.[[:alpha:]]+)?$/
      }.freeze

      DOMAINS_GRADES = {
        'K_8' => ['k'].concat((1..8).to_a.map(&:to_s)),
        '9_12' => (9..12).to_a.map(&:to_s)
      }.freeze

      DOMAINS = {
        'K_8' => {
          'CC' => 'Counting & Cardinality',
          'OA' => 'Operations & Algebraic Thinking',
          'NBT' => 'Number & Operations in Base Ten',
          'MD' => 'Measurement & Data',
          'G' => 'Geometry',
          'NF' => 'Number & Operations—Fractions',
          'RP' => 'Ratios & Proportional Relationships',
          'NS' => 'The Number System',
          'EE' => 'Expressions & Equations',
          'SP' => 'Statistics & Probability',
          'F' => 'Functions'
        },
        '9_12' => {
          'RN' => 'The Real Number System',
          'Q' => 'Quantities*',
          'CN' => 'The Complex Number System',
          'VM' => 'Vector & Matrix Quantities',
          'SSE' => 'Seeing Structure in Expressions',
          'APR' => 'Arithmetic with Polynomials & Rational Expressions',
          'CED' => 'Creating Equations*',
          'REI' => 'Reasoning with Equations & Inequalities',
          'IF' => 'Interpreting Functions',
          'BF' => 'Building Functions',
          'LE' => 'Linear, Quadratic, & Exponential Models*',
          'TF' => 'Trigonometric Functions',
          'CO' => 'Congruence',
          'SRT' => 'Similarity, Right Triangles, & Trigonometry',
          'C' => 'Circles',
          'GPE' => 'Expressing Geometric Properties with Equations',
          'GMD' => 'Geometric Measurement & Dimension',
          'MG' => 'Modeling with Geometry',
          'ID' => 'Interpreting Categorical & Quantitative Data',
          'IC' => 'Making Inferences & Justifying Conclusions',
          'CP' => 'Conditional Probability & the Rules of Probability',
          'MD' => 'Using Probability to Make Decisions'
        }
      }.freeze

      STRANDS = {
        'L' => 'Language',
        'RF' => 'Reading: Foundational Skills',
        'RI' => 'Reading: Informational Text',
        'RL' => 'Reading: Literature',
        'SL' => 'Speaking & Listening',
        'W' => 'Writing'
      }.freeze

      validates :name, presence: true

      has_many :resource_standards, dependent: :destroy
      has_many :resources, through: :resource_standards

      # NOTE: #954 - to be removed
      scope :by_grade, ->(grade) { by_grades [grade] }
      # NOTE: #954 - to be removed
      scope :by_grades, lambda { |grades|
        joins(resource_standards: { resource: [:grades] })
          .where('grades.id' => grades.map(&:id))
      }

      # NOTE: #954 - to be removed
      scope :ela, -> { where(subject: 'ela') }
      scope :math, -> { where(subject: 'math') }

      # NOTE: #954 - to be removed?
      def self.search_by_name(name)
        where('name ILIKE :q OR alt_names::text ILIKE :q', q: "%#{name}%").order(:id)
      end

      # NOTE: #954 - to be removed?
      def self.filter_ccss_standards(name, subject)
        name&.match?(ALT_NAME_REGEX[subject]) ? name.upcase : nil
      end

      # NOTE: #954 - to be removed?
      def short_name
        Array.wrap(alt_names).map { |n| self.class.filter_ccss_standards(n, subject) }.compact.try(:first) || name
      end
    end
  end
end
