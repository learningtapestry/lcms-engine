# frozen_string_literal: true

class AddIndexedAtToLearningObjects < ActiveRecord::Migration[4.2]
  def change
    change_table :learning_objects do |t|
      t.timestamp :indexed_at
    end
  end
end
