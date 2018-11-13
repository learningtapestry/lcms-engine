# frozen_string_literal: true

#
# Import standards from db/data/standards_*.csv files
#
class StandardImporter
  # @param [String] subject Should be `math` or `ela`
  def initialize(subject)
    @subject = subject.to_s
    @source_file = "db/data/standards_#{subject}.csv"
    raise 'Source file not found!' unless File.exist?(@source_file)
  end

  def run
    content = File.read source_file
    ActiveRecord::Base.transaction do
      CSV.parse(content, headers: true) { |row| import row }
    end
  end

  private

  RE_EMPHASIS = /^\(\+\)\s?/

  attr_reader :source_file, :subject

  def find_grade(name)
    key =
      if name.casecmp('pk').zero?
        'prekindergarten'
      elsif name.casecmp('k').zero?
        'kindergarten'
      else
        "grade #{name}"
      end
    # TODO: Add caching here
    Resource.find_by_directory([subject, key]).grades.model
  end

  def find_grades(data)
    grades = []

    from_name, to_name = data.squish.downcase.split('-')
    grades << find_grade(from_name)

    return grades if to_name.blank?

    from_idx = Grades::GRADES_ABBR.index from_name
    to_idx = Grades::GRADES_ABBR.index from_name

    Grades::GRADES_ABBR.slice(from_idx..to_idx).each { |name| grades << find_grade(name) }

    grades.compact
  end

  def import(row)
    grade_name = row[0].to_s.squish
    return if grade_name.blank?

    standard = subject == 'ela' ? standard_ela(grade_name, row) : standard_math(grade_name, row)
    standard.resource_ids = find_grades(row[0]).map(&:id)
  rescue StandardError => e
    puts e.message
    puts row
  end

  def standard_ela(grade_name, data)
    strand = data[1].to_s.squish
    number = data[2].to_s.squish
    name = [grade_name, strand, number].join('.')

    Standard.create!(
      description: data[4].split(' ', 2).last.to_s.squish,
      name: name,
      strand: strand,
      synonyms: data[3].to_s.squish
    )
  end

  def standard_math(grade_name, data)
    cluster = data[3].to_s.squish
    course = data[1].to_s.squish

    description = data[5].to_s.split(' ', 2).last.to_s.squish
    emphasis = description.scan(RE_EMPHASIS)&.send(:[], 0)
    description = description.sub(RE_EMPHASIS, '')

    domain = data[2].to_s.squish
    number = data[4].to_s.squish
    prefix = grade_name.to_i < 9 ? grade_name : course
    name = [prefix, domain, cluster, number].compact.join('.')

    Standard.create!(
      description: description&.squish,
      emphasis: emphasis&.squish,
      name: name,
      course: course,
      domain: domain,
      synonyms: data[3].to_s.squish
    )
  end
end
