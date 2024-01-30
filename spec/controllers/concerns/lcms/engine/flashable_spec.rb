# frozen_string_literal: true

require 'rails_helper'
require 'mock_redis'

describe Lcms::Engine::Flashable, type: :controller do
  controller(ApplicationController) { include Lcms::Engine::Flashable }

  describe '#store_flash_message' do
    context 'when the message is shorter than the maximum character limit' do
      let(:message) { 'This is a test message' }

      subject { controller.store_flash_message(message) }

      it 'returns the original message' do
        expect(subject).to eq message
      end
    end

    context 'when the message is longer than the maximum character limit' do
      let(:long_message) { 'a' * (Lcms::Engine::FLASH_MESSAGE_MAX_CHAR + 1) }

      subject { controller.store_flash_message(long_message) }

      context 'when Redis is configured' do
        before { allow(Rails.application.config).to receive(:redis).and_return(MockRedis.new) }

        it 'stores the message in Redis and returns the key' do
          key = subject
          expect(Rails.application.config.redis.get(key)).to eq long_message
        end
      end

      context 'when Redis is not configured' do
        before { allow(Rails.application.config).to receive(:redis).and_return(nil) }

        it 'logs an error and returns an alternative message' do
          expect(Rails.logger).to receive(:error).twice
          expect(subject).to eq 'Error is too long to be displayed. Please check the logs.'
        end
      end
    end
  end
end
