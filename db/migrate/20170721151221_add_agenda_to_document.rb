# frozen_string_literal: true

class AddAgendaToDocument < Lcms::Engine::Migration
  def change
    add_column :documents, :agenda_metadata, :jsonb
  end
end
