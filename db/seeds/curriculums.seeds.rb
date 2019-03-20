# frozen_string_literal: true

# Default Curriculum
puts '===> Create Curriculum: Default'
default = Lcms::Engine::Curriculum.find_or_create_by(name: 'Default', slug: 'default', default: true)

# add tree resource to default curriculum
puts '===> Add Resources to Curriculum'
Lcms::Engine::Resource.where(tree: true).find_each do |res|
  next if res.curriculum.present?

  res.curriculum = default
  res.save!
  print '.'
end
puts "\n"
