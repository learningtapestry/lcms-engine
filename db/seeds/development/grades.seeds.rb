# frozen_string_literal: true

GRADES = [
  { name: 'grade 9', long_name: 'Grade 9' },
  { name: 'grade 10', long_name: 'Grade 10' },
  { name: 'grade 11', long_name: 'Grade 11' },
  { name: 'grade 12', long_name: 'Grade 12' }
].freeze

Lcms::Engine::Resource.subjects.each do |subject|
  GRADES.each_with_index do |grade, index|
    puts "----> #{subject.title} #{grade[:name]}"
    res = subject.children.detect { |r| r.short_title == grade[:name] }

    metadata = {
      subject: subject.short_title,
      grade: grade[:name]
    }.compact

    if res
      res.title = grade[:long_name]
      res.level_position = index
      res.metadata = metadata
      res.save!
    else
      subject.children.create!(
        short_title: grade[:name],
        title: grade[:long_name],
        level_position: index,
        resource_type: Lcms::Engine::Resource.resource_types[:resource],
        curriculum: Lcms::Engine::Curriculum.default,
        curriculum_type: 'grade',
        tree: true,
        metadata: metadata
      )
    end
  end
end
