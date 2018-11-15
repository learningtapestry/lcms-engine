# frozen_string_literal: true

class RemoveParentFromDocumentPart < Lcms::Engine::Migration
  def change
    remove_reference :document_parts, :parent, index: true
  end
end
