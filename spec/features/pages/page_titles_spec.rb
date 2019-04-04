# frozen_string_literal: true

require 'rails_helper'

feature 'Page Titles' do
  scenario 'home page' do
    visit lcms_engine.root_path
    expect(current_path).to eq lcms_engine.new_user_session_path
  end

  scenario 'about page' do
    create(:page, :about)
    visit lcms_engine.about_path
    expect(current_path).to eq lcms_engine.new_user_session_path
  end

  # NOTE: commented as we have only admin panel for now at openscied
  xcontext 'logged in as user' do
    background { sign_in create :user }

    scenario 'home page' do
      visit lcms_engine.root_path
      expect(page.title).to include(I18n.t 'ui.unbounded')
    end

    scenario 'about page' do
      about = create(:page, :about)
      visit lcms_engine.about_path
      expect(page.title).to include(about.title)
    end

    scenario 'tos page' do
      tos = create(:page, :tos)
      visit lcms_engine.tos_page_path
      expect(page.title).to include(tos.title)
    end

    scenario 'auth pages' do
      logout

      visit lcms_engine.new_user_password_path
      expect(page.title).to include('Forgot Your Password?')

      visit lcms_engine.new_user_session_path
      expect(page.title).to include('Log In')

      visit lcms_engine.new_user_registration_path
      expect(page.title).to include('Create Account')
    end
  end

  context 'logged in as admin' do
    background { sign_in create :admin }

    scenario 'about page' do
      visit lcms_engine.admin_path
      expect(page.title).to include('Admin')
    end

    scenario 'admin page pages' do
      tos = create(:page, :tos)

      visit lcms_engine.admin_pages_path
      expect(page.title).to include('Pages')

      visit lcms_engine.new_admin_page_path
      expect(page.title).to include('New Page')

      visit lcms_engine.edit_admin_page_path(tos.id)
      expect(page.title).to include("Edit #{tos.title} Page")
    end

    scenario 'admin resources pages' do
      resource = create(:resource)

      visit lcms_engine.admin_resources_path
      expect(page.title).to include('Content Administration')

      visit lcms_engine.new_admin_resource_path
      expect(page.title).to include('New Resource')

      visit lcms_engine.edit_admin_resource_path(resource.id)
      expect(page.title).to include("Edit #{resource.title}")
    end
  end
end
