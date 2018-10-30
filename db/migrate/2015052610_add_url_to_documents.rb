# frozen_string_literal: true

class AddUrlToDocuments < ActiveRecord::Migration[4.2]
  def change
    change_table :documents do |t|
      t.remove :resource_locator
      t.belongs_to :url
    end
  end
end
