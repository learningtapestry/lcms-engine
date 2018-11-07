# frozen_string_literal: true

namespace :resources do
  desc 'Fix curriculum metadata'
  task(fix_metadata: [:environment]) { ResourceTasks.fix_metadata }

  desc 'Generate Unit Document Bundles'
  task(generate_bundles: [:environment]) { ResourceTasks.generate_unit_bundles }

  desc 'Generate hierarchical positions for resources'
  task(generate_positions: [:environment]) { GenerateHierarchicalPositions.new.generate! }

  desc 'Generate slugs'
  task(generate_slugs: [:environment]) { Slug.generate_resources_slugs }

  desc 'Updates time to teach resources'
  task(update_time_to_teach: [:environment]) { ResourceTasks.update_time_to_teach }

  desc 'Sync reading assignment'
  task(sync_reading_assignments: [:environment]) { ResourceTasks.sync_reading_assignments }

  desc 'Clear detached/orphan resources'
  task clear_detached: :environment do
    rtype = Resource.resource_types[:resource]
    detached = Resource.where(tree: false, resource_type: rtype)
    puts "===> Removing #{detached.count} detached resources"
    detached.destroy_all
  end
end
