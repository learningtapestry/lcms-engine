# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::AdminController do
  describe '.host_engine_path' do
    let(:args) { { query: 'test', filter: '1' } }

    subject { described_class.host_engine_path(:root_path, args) }

    context 'with host redirect' do
      it 'builds correct path' do
        expect(subject).to eq "/lcms-engine/admin?#{args.to_param}"
      end
    end

    context 'with engine redirect' do
      let(:settings) do
        settings = described_class.settings
        settings[:redirect].delete(:host)
        settings
      end

      before { allow(described_class).to receive(:settings).and_return(settings) }

      it 'builds correct path' do
        expect(subject).to eq "/lcms-engine/admin?#{args.to_param}"
      end
    end
  end
end
