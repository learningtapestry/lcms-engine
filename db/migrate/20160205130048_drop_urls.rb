# frozen_string_literal: true

class DropUrls < ActiveRecord::Migration[4.2]
  def change
    drop_table :lobject_urls
    drop_table :urls
  end
end
