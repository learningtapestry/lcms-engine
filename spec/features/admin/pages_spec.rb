# frozen_string_literal: true

require 'rails_helper'

feature 'Admin pages' do
  given(:admin) { create(:admin) }
  given(:ub_page) { create(:page) }

  given(:body) { Faker::Lorem.sentence(100) }
  given(:title) { Faker::Lorem.sentence(10) }
  given(:slug) { Faker::Internet.slug }

  background { login_as admin }

  scenario 'new page' do
    visit lcms_engine.admin_pages_path

    click_link 'Add Page'
    expect(current_path).to eq lcms_engine.new_admin_page_path

    click_button 'Save'
    expect(find('.input.page_title.error .error').text).to eq "can't be blank"
    expect(find('.input.page_body.error .error').text).to eq "can't be blank"

    fill_in 'Title', with: title
    fill_in 'Body',  with: body
    fill_in 'Slug',  with: slug
    click_button 'Save'

    page = Lcms::Engine::Page.last
    expect(page.body).to eq body
    expect(page.title).to eq title
    expect(current_path).to eq lcms_engine.page_path(page.id)
    expect(find('.callout.success').text).to have_content 'Page created successfully'
  end

  scenario 'show page' do
    logout
    sign_in create :user

    visit lcms_engine.page_path(ub_page.id)

    expect(first(:xpath, '//h2').text).to eq ub_page.title
    expect(find('.page-body').text).to eq ub_page.body
  end

  scenario 'edit page' do
    ub_page

    visit lcms_engine.admin_pages_path

    within "#page_#{ub_page.id}" do
      click_link 'Edit'
    end
    expect(current_path).to eq lcms_engine.edit_admin_page_path(ub_page.id)

    fill_in 'Title', with: title
    fill_in 'Body',  with: body
    click_button 'Save'

    ub_page.reload

    expect(ub_page.body).to eq body
    expect(ub_page.title).to eq title
    expect(current_path).to eq lcms_engine.page_path(ub_page.id)
    expect(find('.callout.success').text).to have_content 'Page updated successfully'
  end

  scenario 'delete page' do
    ub_page
    visit lcms_engine.admin_pages_path
    within "#page_#{ub_page.id}" do
      click_button 'Delete'
    end
    expect(Lcms::Engine::Page.find_by id: ub_page.id).to be_nil
    expect(current_path).to eq lcms_engine.admin_pages_path
    expect(find('.callout.success').text).to have_content 'Page deleted successfully'
  end
end
