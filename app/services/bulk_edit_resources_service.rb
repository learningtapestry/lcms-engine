# frozen_string_literal: true

class BulkEditResourcesService
  def initialize(resources, params = nil)
    @resources = resources
    @params = params
  end

  def init_sample
    resource = Resource.new
    resource.standard_ids = @resources.map(&:standard_ids).inject { |memo, ids| memo & ids }
    resource
  end

  def edit!
    before = init_sample
    after = Resource.new(@params)

    Resource.transaction do
      @resources.each do |resource|
        # Standards
        resource.resource_standards
          .where(standard_id: before.standard_ids)
          .where.not(standard_id: after.standard_ids)
          .destroy_all

        (after.standard_ids - before.standard_ids).each do |standard_id|
          resource.resource_standards.find_or_create_by!(standard_id: standard_id)
        end

        resource.metadata['grade'] = after.metadata['grade']
        resource.tag_list = after.tag_list
        resource.resource_type_list = after.resource_type_list

        resource.save!
      end
    end
  end
end
