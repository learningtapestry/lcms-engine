# frozen_string_literal: true

class AddMainToDownloads < ActiveRecord::Migration[4.2]
  def change
    add_column :downloads, :main, :boolean, null: false, default: false
  end
end
