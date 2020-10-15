# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::AssociationPickerController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#index' do
    %w(content_sources tags grades topics reading_assignment_authors reading_assignment_texts standards)
      .each do |assoc|
        it "list #{assoc} association items" do
          get :index, association: assoc, format: :json
          expect(response).to be_success
        end
      end
  end
end
