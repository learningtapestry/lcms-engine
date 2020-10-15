# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :document do
  desc 'Outputs a JSON document showing the document hierarchy'
  task :hierarchy, [:grade_number] => [:environment] do |_task, args|
    documents = Document
                  .where("metadata ->> 'subject' = ?", 'math')
                  .where("metadata ->> 'grade' = ?", args[:grade_number].to_s)
                  .all

    hierarchy = {}

    documents.each do |document|
      grade_key = "grade-#{document.metadata['grade']}"
      hierarchy[grade_key] ||= {}
      grade = hierarchy[grade_key]

      grade['subject'] ||= 'math'
      grade['modules'] ||= {}

      module_key = "module-#{document.metadata['unit']}"
      grade['modules'][module_key] ||= {}
      module_ = grade['modules'][module_key]

      module_['name'] ||= '[name]'
      module_['topics'] ||= {}

      topic_key = "topic-#{document.metadata['topic']}"
      module_['topics'][topic_key] ||= {}
      topic = module_['topics'][topic_key]

      topic['name'] ||= '[name]'
      topic['lessons'] ||= []

      file_name = Ibm::DocumentPresenter.new(document).html_filename
      lesson_number = file_name.match(/Math_G.+_M.+_T.+_L(.+)_/)[1]

      topic['lessons'].push(
        'file_name' => file_name,
        'identifier' => 'ENY-' \
          "G#{grade_key.split('-').last}-" \
          "M#{module_key.split('-').last}-" \
          "T#{topic_key.split('-').last}-" \
          "L#{lesson_number}",
        'name' => document.metadata['title_text'],
        'standards' => document.metadata['standard'],
        'description' => Nokogiri::HTML(document.metadata['description']).text,
        'objective' => Nokogiri::HTML(document.metadata['lesson-objective']).text
      )
    end

    # sort the hierarchy

    grade_key = "grade-#{args[:grade_number]}"

    hierarchy[grade_key]['modules'] = hierarchy[grade_key]['modules'].sort.to_h
    modules = hierarchy[grade_key]['modules']

    modules.each do |module_key, module_|
      modules[module_key]['topics'] = module_['topics'].sort.to_h
      topics = modules[module_key]['topics']

      topics.each_key do |topic_key|
        topics[topic_key]['lessons'].sort_by! do |t|
          t['file_name'].match(/Math_G.+_M.+_T.+_L(.+)_/)[1].to_i
        end
      end
    end

    puts hierarchy.to_json
  end
end
# rubocop:enable Metrics/BlockLength
