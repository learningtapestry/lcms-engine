# frozen_string_literal: true

class SurveyForm
  include Virtus.model
  include ActiveModel::Model

  DISTRICT_OR_SCHOOL_SYSTEMS = [
    'AUSL (IL)',
    'DC International (DC)',
    'DC Prep (DC)',
    'Lawrence (MA)',
    'Other'
  ].freeze

  SUBJECT_OR_GRADES = [
    'Grade 2 ELA',
    'Grade 6 ELA',
    'Grade 4 Math',
    'Grade 7 Math',
    'Other'
  ].freeze

  PRIOR_EXPERIENCES = [
    "Yes, I've used them as primary materials",
    "Yes, I've used them as supporting materials",
    'No, I have not used them'
  ].freeze

  attribute :first_name, String
  attribute :last_name, String
  attribute :district_or_system, String
  attribute :district_or_system_other, String
  attribute :subject_or_grade, String
  attribute :subject_or_grade_other, String
  attribute :number_of_minutes, Integer
  attribute :additional_period, String
  attribute :additional_period_minutes, String
  attribute :prior_experience, String

  validates_presence_of :additional_period, :district_or_system,
                        :first_name, :last_name, :number_of_minutes,
                        :prior_experience, :subject_or_grade

  validates_numericality_of :number_of_minutes, greater_than: 0
end
