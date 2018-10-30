# frozen_string_literal: true

class CreateLearningResourceLocators < ActiveRecord::Migration[4.2]
  def change
    create_table :learning_resource_locators do |t|
      t.string :url
      t.timestamps
    end
  end
end
