# frozen_string_literal: true

class DropLobjectTitleDescription < Lcms::Engine::Migration
  def change
    change_table :lobjects do |t|
      t.remove :title
      t.remove :description
    end
  end
end
