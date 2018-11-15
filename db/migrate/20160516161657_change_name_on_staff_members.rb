# frozen_string_literal: true

class ChangeNameOnStaffMembers < Lcms::Engine::Migration
  def change
    add_column :staff_members, :first_name, :string
    add_column :staff_members, :last_name, :string
    add_column :staff_members, :order, :integer

    add_index :staff_members, %i(first_name last_name)

    remove_column :staff_members, :name, :string
  end
end
