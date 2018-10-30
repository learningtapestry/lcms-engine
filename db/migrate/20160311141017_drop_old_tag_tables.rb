# frozen_string_literal: true

class DropOldTagTables < ActiveRecord::Migration[4.2]
  def change
    drop_table :resource_grades
    drop_table :grades

    drop_table :resource_topics
    drop_table :topics

    drop_table :resource_subjects
    drop_table :subjects

    drop_table :resource_resource_types
    drop_table :resource_types
  end
end
