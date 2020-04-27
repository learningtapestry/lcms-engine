# frozen_string_literal: true

require 'rails_helper'

# NOTE: Sample request spec. Should be used as a template to migrate
#       all other controller specs
xdescribe 'Admin Panel: Curriculum' do
  let(:user) { create :admin }

  before { sign_in user }

  it 'request for editing' do
    get lcms_engine.edit_admin_curriculum_path

    # Test whatever need here...
  end
end
