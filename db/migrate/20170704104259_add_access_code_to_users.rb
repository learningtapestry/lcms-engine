# frozen_string_literal: true

class AddAccessCodeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :access_code, :string
  end
end
