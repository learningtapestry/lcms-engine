# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags do
  describe 'config storage' do
    it 'stores config in module instance variable' do
      expect(described_class.config).to be_a(Hash)
    end
  end
end
