# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::S3Service do
  describe '.upload' do
    let(:data) { StringIO.new('data to be uploaded') }
    let(:full_options) do
      options.merge(body: data, cache_control: 'public, max-age=0, must-revalidate',
                    metadata_directive: 'REPLACE')
    end
    let(:key) { 'path/to/file' }
    let(:object) do
      params = {
        put: 'true',
        public_url: url
      }
      double(Aws::S3::Resource, **params)
    end
    let(:options) { { content_type: 'image/png' } }
    let(:url) { Faker::Internet.url }

    before { allow(described_class).to receive(:create_object).with(key).and_return(object) }

    subject { described_class.upload(key, data, options) }

    it 'uploads data with passed params' do
      expect(object).to receive(:put).with(full_options)
      subject
    end

    it 'returns URL of the uploaded object'
  end
end
