# frozen_string_literal: true

class CreateLearningResourceLocators < Lcms::Engine::Migration
  def change
    create_table :learning_resource_locators do |t|
      t.string :url
      t.timestamps
    end
  end
end
