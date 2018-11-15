# frozen_string_literal: true

class CreateLeadershipPosts < Lcms::Engine::Migration
  def change
    create_table :leadership_posts do |t|
      t.string :first_name
      t.string :last_name
      t.string :school
      t.string :image_file
      t.string :dsc, limit: 4096
      t.integer :order

      t.timestamps null: false
    end
    add_index :leadership_posts, %i(order last_name)
  end
end
