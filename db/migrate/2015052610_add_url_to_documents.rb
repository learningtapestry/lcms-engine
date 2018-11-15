# frozen_string_literal: true

class AddUrlToDocuments < Lcms::Engine::Migration
  def change
    change_table :documents do |t|
      t.remove :resource_locator
      t.belongs_to :url
    end
  end
end
