# frozen_string_literal: true

class CreateResourceSlugs < Lcms::Engine::Migration
  def up
    ActiveRecord::Base.connection.execute('drop table if exists resource_slugs;')

    create_table :resource_slugs do |t|
      t.references :resource, index: true, foreign_key: true, null: false
      t.references :curriculum, index: true, foreign_key: true
      t.boolean :canonical, index: true, null: false, default: true
      t.string :value, null: false
    end

    add_index :resource_slugs, :value, unique: true

    # Only one canonical may exist per resource_id or curriculum_id.
    ActiveRecord::Base.connection.execute(%{
      create unique index
        resource_slugs_cur_canonical_unique
        on resource_slugs (resource_id, curriculum_id)
        where canonical;
    })
  end

  def down
    drop_table :resource_slugs
  end
end
