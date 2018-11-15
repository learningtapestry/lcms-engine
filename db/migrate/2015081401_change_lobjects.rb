# frozen_string_literal: true

class ChangeLobjects < Lcms::Engine::Migration
  def change
    change_table :lobjects do |t|
      t.boolean :hidden, index: true, default: false
    end
  end
end
