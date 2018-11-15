# frozen_string_literal: true

class RemoveParentIdColumns < Lcms::Engine::Migration
  def change
    remove_column :alignments, :parent_id
    remove_column :downloads, :parent_id
    remove_column :grades, :parent_id
    remove_column :identities, :parent_id
    remove_column :languages, :parent_id
    remove_column :resource_types, :parent_id
    remove_column :subjects, :parent_id
    remove_column :topics, :parent_id
  end
end
