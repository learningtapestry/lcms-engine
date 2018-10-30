# frozen_string_literal: true

class AddHttpStatusToLearningResourceLocators < ActiveRecord::Migration[4.2]
  def change
    change_table :learning_resource_locators do |t|
      t.integer :http_status
      t.timestamp :checked_at
    end
  end
end
