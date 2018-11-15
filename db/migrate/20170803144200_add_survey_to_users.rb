# frozen_string_literal: true

class AddSurveyToUsers < Lcms::Engine::Migration
  def change
    add_column :users, :survey, :hstore
  end
end
