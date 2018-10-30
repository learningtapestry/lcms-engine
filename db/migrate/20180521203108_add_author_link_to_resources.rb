# frozen_string_literal: true

class AddAuthorLinkToResources < ActiveRecord::Migration[4.2]
  def change
    add_reference :resources, :author, index: true
  end
end
