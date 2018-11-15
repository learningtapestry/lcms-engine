# frozen_string_literal: true

class AddIndexedAtToLearningObjects < Lcms::Engine::Migration
  def change
    change_table :learning_objects do |t|
      t.timestamp :indexed_at
    end
  end
end
