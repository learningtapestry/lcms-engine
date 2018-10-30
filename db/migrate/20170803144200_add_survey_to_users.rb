# frozen_string_literal: true

class AddSurveyToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :survey, :hstore
  end
end
