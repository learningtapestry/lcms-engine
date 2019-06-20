# frozen_string_literal: true

module ResourceFactoryHelper
  def resources_sample_collection
    # ELA G2 => 2 lessons
    2.times do |i|
      pos = i + 1
      dir = ['ela', 'grade 2', 'module 1', 'unit 1', "lesson #{pos}"]
      create(:resource,
             title: "Test Resource ELA G2 L#{pos}",
             metadata: ::Lcms::Engine::Resource.metadata_from_dir(dir))
    end

    # ELA G6 => 6 lessons
    6.times do |i|
      pos = i + 1
      dir = ['ela', 'grade 6', 'module 1', 'unit 1', "lesson #{pos}"]
      create(:resource,
             title: "Test Resource ELA G6 L#{pos}",
             metadata: ::Lcms::Engine::Resource.metadata_from_dir(dir))
    end

    # Math G4 => 4 lessons
    4.times do |i|
      pos = i + 1
      dir = ['math', 'grade 4', 'module 1', 'unit 1', "lesson #{pos}"]
      create(:resource,
             title: "Test Resource Math G4 L#{pos}",
             metadata: ::Lcms::Engine::Resource.metadata_from_dir(dir))
    end

    # Math G7 => 7 lessons
    7.times do |i|
      pos = i + 1
      dir = ['math', 'grade 7', 'module 1', 'unit 1', "lesson #{pos}"]
      create(:resource,
             title: "Test Resource Math G7 L#{pos}",
             metadata: ::Lcms::Engine::Resource.metadata_from_dir(dir))
    end
  end

  def build_resources_chain(curr)
    dir = []
    parent = nil
    ::Lcms::Engine::Resource::HIERARCHY.each_with_index do |type, idx|
      next unless curr[idx]

      dir.push curr[idx]
      res = create(:resource,
                   title: "Test Resource #{dir.join('|')}",
                   short_title: curr[idx],
                   curriculum_type: type,
                   parent: parent,
                   metadata: ::Lcms::Engine::Resource.metadata_from_dir(dir))
      parent = res
    end
  end

  def build_or_return_resources_chain(curr)
    dir = []
    parent = nil
    ::Lcms::Engine::Resource::HIERARCHY.each_with_index do |type, idx|
      next unless curr[idx]

      dir.push curr[idx]
      res = ::Lcms::Engine::Resource.find_by(short_title: curr[idx]) ||
            create(:resource,
                   title: "Test Resource #{dir.join('|')}",
                   short_title: curr[idx],
                   curriculum_type: type,
                   parent: parent,
                   metadata: ::Lcms::Engine::Resource.metadata_from_dir(dir))
      parent = res
    end
    parent
  end
end

RSpec.configure do |config|
  config.include ResourceFactoryHelper
end
