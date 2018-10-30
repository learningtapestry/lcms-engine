# frozen_string_literal: true

class CreateSocialThumbnails < ActiveRecord::Migration[4.2]
  def change
    create_table :social_thumbnails do |t|
      t.references :target, polymorphic: true, null: false, index: true
      t.string     :image, null: false
      t.string     :media, null: false
    end
  end
end
