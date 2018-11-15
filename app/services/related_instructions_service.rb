# frozen_string_literal: true

class RelatedInstructionsService
  attr_reader :resource, :expanded, :has_more, :instructions

  def initialize(resource, expanded)
    @resource = resource
    @expanded = expanded

    find_related_instructions
  end

  private

  def find_related_instructions
    instructions = expanded ? expanded_instructions : colapsed_instructions

    @has_more = true if videos.size > instructions.size
    @instructions = instructions.map do |inst|
      ResourceInstructionSerializer.new(inst)
    end
  end

  def expanded_instructions
    videos
  end

  def colapsed_instructions
    # show 4 videos
    videos[0...4]
  end

  def videos
    @videos ||= find_related_through_standards(limit: 4) do |standard|
      standard.resources.media.distinct
    end
  end

  def find_related_through_standards(limit:, &_block)
    related = resource.standards.flat_map do |standard|
      qset = yield standard
      qset = qset.limit(limit) unless expanded # limit each part
      qset
    end.uniq

    if expanded
      related
    else
      @has_more = true if related.count > limit
      related[0...limit] # limit total
    end
  end
end
