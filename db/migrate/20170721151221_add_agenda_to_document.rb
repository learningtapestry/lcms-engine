# frozen_string_literal: true

class AddAgendaToDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :agenda_metadata, :jsonb
  end
end
