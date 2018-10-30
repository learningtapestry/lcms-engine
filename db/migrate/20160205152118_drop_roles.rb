# frozen_string_literal: true

class DropRoles < ActiveRecord::Migration[4.2]
  def change
    drop_table :user_roles
    drop_table :roles
  end
end
