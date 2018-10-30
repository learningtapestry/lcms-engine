# frozen_string_literal: true

class AddSomeMetadataToContentGuides < ActiveRecord::Migration[4.2]
  def change
    add_column :content_guides, :last_modified_at, :datetime
    add_column :content_guides, :last_modifying_user_email, :string
    add_column :content_guides, :last_modifying_user_name, :string
    add_column :content_guides, :version, :integer
  end
end
