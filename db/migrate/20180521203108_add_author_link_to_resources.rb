# frozen_string_literal: true

class AddAuthorLinkToResources < Lcms::Engine::Migration
  def change
    add_reference :resources, :author, index: true
  end
end
