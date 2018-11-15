# frozen_string_literal: true

class CreateStaffMembers < Lcms::Engine::Migration
  def change
    create_table :staff_members do |t|
      t.string :bio, limit: 4096
      t.string :name, null: false
      t.string :position

      t.timestamps null: false
    end
  end
end
