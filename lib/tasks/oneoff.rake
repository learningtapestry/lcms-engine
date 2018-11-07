# frozen_string_literal: true

namespace :oneoff do # rubocop:disable Metrics/BlockLength
  task fix_math_docs_module_metadata: :environment do
    puts '====> Fix Math Documents Module Metadata'
    Document.filter_by_subject('math').each do |d|
      d.metadata['module'] = d.metadata['unit'] unless d.metadata['module']
      d.save
    end
  end

  task fix_level_positions: :environment do
    def consecutive?(level)
      level.zip(0..level.size).all? { |num, index| num == index }
    end

    def fix_positions(res)
      puts "Fix order for #{res.slug}"
      puts "from #{res.children.pluck(:level_position).inspect}"
      res.children.each_with_index do |r, index|
        if r.level_position != index
          r.level_position = index
          r.save!
        end
      end
      puts "to   #{res.reload.children.pluck(:level_position).inspect}\n\n"
    end

    def check_node(res)
      fix_positions(res) unless consecutive? res.children.pluck(:level_position)
      res.children.each { |c| check_node c }
    end

    Resource.tree.roots.each { |r| check_node(r) }
  end
end
