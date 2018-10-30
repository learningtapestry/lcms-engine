# frozen_string_literal: true

class ChangeSubjectInStandards < ActiveRecord::Migration[4.2]
  def change
    ActiveRecord::Base.connection.execute(%{
      update standards set subject = 'ela' where substr(name,1,3) = 'ELA';
      update standards set subject = 'math' where substr(name,1,4) = 'Math';
    })

    change_column :standards, :subject, :string, null: false
  end
end
