# frozen_string_literal: true

class AddFieldsToStaffMembers < ActiveRecord::Migration[4.2]
  def change
    change_table :staff_members do |t|
      t.integer :staff_type, default: 1, null: false
      t.string :image_file
      t.string :department
    end
  end
end
