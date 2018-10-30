# frozen_string_literal: true

class ChangeResourceReadingAssignments < ActiveRecord::Migration[4.2]
  def change
    change_table :resource_reading_assignments do |t|
      t.remove :title
      t.remove :text_type
      t.remove :author
      t.references :reading_assignment_text,
                   index: { name: 'idx_res_rea_asg_rea_asg_txt' },
                   foreign_key: { name: 'fk_res_rea_asg_rea_asg_txt' },
                   null: false
    end
  end
end
