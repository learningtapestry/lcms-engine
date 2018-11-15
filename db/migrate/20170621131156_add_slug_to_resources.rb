# frozen_string_literal: true

class AddSlugToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :slug, :string, index: true
  end

  def data
    Resource.where.not(curriculum_tree_id: nil).find_each do |res|
      res.update_columns slug: Slug.new(res).value
    end
  end
end
