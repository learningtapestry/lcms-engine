# frozen_string_literal: true

class DropDelayedJobs < Lcms::Engine::Migration
  def change
    drop_table :delayed_jobs
  end
end
