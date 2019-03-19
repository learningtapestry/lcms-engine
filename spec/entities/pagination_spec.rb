# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Pagination do
  describe 'params' do
    it 'has defaults' do
      pagination = described_class.new({})
      expect(pagination.params[:page]).to eq 1
      expect(pagination.params[:per_page]).to eq 20
      expect(pagination.params[:order]).to eq :asc
    end

    it 'filters invalid keys' do
      pagination = described_class.new page: 3, something: 'else'
      expect(pagination.params[:page]).to eq 3
      expect(pagination.params.keys).to eq %i(page per_page order)
    end

    it 'has a strict mode (used for search)' do
      pagination = described_class.new page: 3
      expect(pagination.params(strict: true).keys).to eq %i(page per_page)
    end
  end
end
