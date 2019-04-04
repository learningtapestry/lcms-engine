# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Search::Document do
  describe 'build_from' do
    let(:title) { 'title' }

    it 'builds from external page' do
      object = described_class.build_from Lcms::Engine::ExternalPage.new(title: title)
      expect(object.title).to eq title
      expect(object.doc_type).to eq 'page'
    end

    it 'builds from resource' do
      object = described_class.build_from create(:resource, title: title)
      expect(object.title).to eq title
      expect(object.doc_type).to eq 'lesson'
      expect(object.breadcrumbs).to eq 'ELA / G2 / M1 / U1 / lesson 1'
    end
  end
end
