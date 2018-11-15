# frozen_string_literal: true

class RenameLearningResourceLocatorColumns < Lcms::Engine::Migration
  def change
    rename_column :lobject_urls, :learning_resource_locator_id, :url_id
  end
end
