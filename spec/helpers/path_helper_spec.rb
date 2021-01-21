# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::PathHelper do
  describe '#dynamic_path' do
    let(:args) { { query: 'test', filter: '1' } }

    subject { helper.dynamic_path(:root_path, args) }

    context 'with host redirect' do
      it 'builds correct path' do
        expect(subject).to eq "/admin?#{args.to_param}"
      end
    end

    context 'with engine redirect' do
      let(:settings) do
        settings = Lcms::Engine::Admin::AdminController.settings
        settings[:redirect].delete(:host)
        settings
      end

      before { allow(Lcms::Engine::Admin::AdminController).to receive(:settings).and_return(settings) }

      it 'builds correct path' do
        expect(subject).to eq "/lcms-engine/admin?#{args.to_param}"
      end
    end
  end
end
