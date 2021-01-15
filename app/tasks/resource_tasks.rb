# frozen_string_literal: true

class ResourceTasks
  def self.fix_metadata
    Resource.tree.find_each do |res|
      curr_meta = res.self_and_ancestors.each_with_object({}) do |r, obj|
        obj[r.curriculum_type] = r.short_title
      end
      res.metadata.merge! curr_meta
      res.save
    end
  end

  def self.generate_unit_bundles
    Resource.tree.units.each do |unit|
      DocumentBundle::CATEGORIES.each do |category|
        DocumentBundle.update_bundle(unit, category)
        print '.'
      end
    rescue Exception => e # rubocop:disable Lint/RescueException
      puts "Err on update_bundle for #{unit.slug} #{category} : #{e.message}"
    end
    puts "\n"
  end

  def self.sync_reading_assignments
    ActiveRecord::Base.transaction do
      %i(units modules grades).each do |level|
        Resource.tree.send(level).find_each do |res|
          res.reading_assignments.destroy_all
          text_ids = res.children.joins(:resource_reading_assignments).pluck(:reading_assignment_text_id).uniq
          text_ids.each { |id| ResourceReadingAssignment.create(resource_id: res.id, reading_assignment_text_id: id) }
        end
      end
    end
  end

  def self.update_time_to_teach
    ActiveRecord::Base.transaction do
      Resource.lessons.find_each do |res|
        next if res.time_to_teach.present? && res.time_to_teach != 0

        res.update(time_to_teach: 60)
      end

      %i(units modules grades subjects).each do |level|
        Resource.send(level).find_each do |res|
          total = res.children.map(&:time_to_teach).sum
          res.update(time_to_teach: total)
        end
      end
    end
  end
end
