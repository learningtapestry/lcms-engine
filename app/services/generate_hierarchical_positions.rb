# frozen_string_literal: true

class GenerateHierarchicalPositions
  def initialize(queryset = nil)
    @queryset = queryset || Resource.all
  end

  def generate!
    puts "====> Generating Resource hierarchical positions\n"
    @queryset.each do |res|
      # obs: were we want a simple sql update statement, without rails callbacks
      res.update_columns hierarchical_position: HierarchicalPosition.new(res).position
      print '.'
    end
    puts "\n"
  end
end
