# frozen_string_literal: true

class ChangeUrlsUrlType < ActiveRecord::Migration[4.2]
  def change
    change_column :urls, :url, :text, null: false
  end
end
