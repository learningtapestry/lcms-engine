# frozen_string_literal: true

class AddLobjectSourceRefs < Lcms::Engine::Migration
  def change
    add_reference :lobject_age_ranges, :document
    add_reference :lobject_descriptions, :document
    add_reference :lobject_identities, :document
    add_reference :lobject_titles, :document
    add_reference :lobject_urls, :document
    add_reference :lobjects_alignments, :document
    add_reference :lobjects_keywords, :document
  end
end
