# frozen_string_literal: true

class AddActiveFieldsEngageny < ActiveRecord::Migration[4.2]
  def change
    change_table :engageny_documents do |t|
      t.boolean :active
    end

    change_table :documents do |t|
      t.boolean :active
    end

    change_table :document_downloads do |t|
      t.boolean :active
    end

    change_table :lobject_downloads do |t|
      t.boolean :active
    end
  end
end
