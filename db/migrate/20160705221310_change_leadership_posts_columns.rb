# frozen_string_literal: true

class ChangeLeadershipPostsColumns < Lcms::Engine::Migration
  def change
    change_table :leadership_posts do |t|
      t.change :first_name, :string, null: false
      t.change :last_name, :string, null: false
      t.rename :dsc, :description
    end
  end
end
