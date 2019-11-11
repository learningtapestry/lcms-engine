# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Template do
  context 'Tags management' do
    describe '.unregister_tag' do
      let(:tag_name) { 'Tag name' }

      subject { described_class.unregister_tag tag_name }

      before { described_class.register_tag tag_name, Object }

      it 'removes specified tag from the list of registered' do
        expect(described_class.tags.keys).to include(tag_name)
        subject
        expect(described_class.tags.keys).to_not include(tag_name)
      end
    end
  end
end
