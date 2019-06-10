# frozen_string_literal: true

require 'rails_helper'

feature 'Page Not Found' do
  background { sign_in create(:user) }

  scenario '404 page' do
    assert_not_found '/lcms-engine/404'
  end

  scenario 'media page' do
    assert_not_found lcms_engine.media_path(:wtf)
  end

  scenario 'resource page' do
    assert_not_found lcms_engine.resource_path(:fake_resource)
  end

  def assert_not_found(path)
    visit path
    expect(page.status_code).to eq 404
    expect(page.title).to eq I18n.t('lcms.engine.pages.not_found.page_title')
    expect(page.has_link?('Search page', href: lcms_engine.search_path)).to be_truthy
  end
end
