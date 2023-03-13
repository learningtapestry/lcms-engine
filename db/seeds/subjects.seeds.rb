# frozen_string_literal: true

SUBJECTS = { ela: 'ELA', math: 'Math' }.freeze

SUBJECTS.each do |short_title, title|
  Lcms::Engine::Resource
    .find_or_create_by(curriculum_type: 'subject', short_title:) do |r|
      r.curriculum_id = Lcms::Engine::Curriculum.default&.id
      r.metadata = { subject: short_title }
      r.short_title = short_title
      r.title = title
      r.tree = true
    end
end
