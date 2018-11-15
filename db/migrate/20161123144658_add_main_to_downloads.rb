# frozen_string_literal: true

class AddMainToDownloads < Lcms::Engine::Migration
  def change
    add_column :downloads, :main, :boolean, null: false, default: false
  end
end
