# frozen_string_literal: true

require 'rails_helper'
require 'rake'
require 'seedbank'

describe Lcms::Engine::PagesController do
  before(:all) do
    Seedbank.load_tasks
    Rake::Task.define_task(:environment)
    Rake::Task['db:seed:pages'].invoke
  end

  before { sign_in create :user }

  describe 'about page' do
    before { get :show_slug, slug: 'about' }
    it { expect(response).to be_successful }
  end

  describe 'about_people page' do
    before { get :show_slug, slug: 'about_people' }
    it { expect(response).to be_successful }
  end

  describe 'tos page' do
    before { get :show_slug, slug: 'tos' }
    it { expect(response).to be_successful }
  end

  describe 'privacy page' do
    before { get :show_slug, slug: 'privacy' }
    it { expect(response).to be_successful }
  end
end
