# frozen_string_literal: true

require 'rails_helper'

feature 'Admin adds a lesson' do
  SAMPLE_LESSON_PATH = 'spec/features/admin/lessons/sample-lessons'

  DownloadedFile = Struct.new :last_modifying_user, :modified_time, :name, :version

  given(:sample_lessons) do
    [
      {
        url: 'https://docs.google.com/document/d/1bchFI5UHmho23z46oB1hR4WftptTILtnJNrrz3HeRaE/edit',
        file_name: 'math-g4.html'
      },
      {
        url: 'https://docs.google.com/document/u/1/d/1PMuE2tXozF-rR7h32oqs9Br2qre04rTmh8TH6aFwo1o/edit',
        file_name: 'math-g7.html'
      },
      {
        url: 'https://docs.google.com/document/d/1Aj5wIu8FWENxV6_qf5znaUDrs6XM7JnFaAzVCc-Q9_U/edit',
        file_name: 'ela-g2.html'
      },
      {
        url: 'https://docs.google.com/document/d/16sDahoxlTIoGwp8SrtrGDao98GQuZMQnoc-7PKOUxUM/edit',
        file_name: 'ela-g6.html'
      }
    ]
  end
  given(:user) { create :admin }

  background do
    sign_in user
  end

  # TODO: Need full refactor after #558
  # TODO: Need full refactoring as we use `lt-lcms` gem for those operations,
  # see the similar specs for Material object
  xscenario 'admin adds sample lessons', :js do
    sample_lessons.each_with_index do |data, idx|
      visit new_admin_document_path
      expect(page).to have_field :document_form_link

      # stub GDoc download
      file_content = File.read File.join(SAMPLE_LESSON_PATH, data[:file_name])
      allow_any_instance_of(DocumentDownloader::Gdoc).to receive(:file).and_return(DownloadedFile.new(nil, nil, idx))
      allow_any_instance_of(DocumentDownloader::Gdoc).to receive(:content).and_return(file_content)

      fill_in :document_form_link, with: data[:url]
      click_button 'Parse'

      expect(Document.last.name).to eql(idx.to_s)
    end
  end
end
