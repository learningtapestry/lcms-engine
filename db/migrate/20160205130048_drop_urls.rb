# frozen_string_literal: true

class DropUrls < Lcms::Engine::Migration
  def change
    drop_table :lobject_urls
    drop_table :urls
  end
end
