# frozen_string_literal: true

class ChangeUrlsUrlType < Lcms::Engine::Migration
  def change
    change_column :urls, :url, :text, null: false
  end
end
