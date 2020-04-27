# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe Lcms::Engine::PagesController do
  before(:all) do
    load File.expand_path '../../db/seeds/pages.seeds.rb', __dir__
  end

  before { sign_in create :user }

  describe 'about page' do
    before { get :show_slug, params: { slug: 'about' } }
    it { expect(response).to be_successful }
  end

  describe 'about_people page' do
    before { get :show_slug, params: { slug: 'about_people' } }
    it { expect(response).to be_successful }
  end

  describe 'tos page' do
    before { get :show_slug, params: { slug: 'tos' } }
    it { expect(response).to be_successful }
  end

  describe 'privacy page' do
    before { get :show_slug, params: { slug: 'privacy' } }
    it { expect(response).to be_successful }
  end
end
