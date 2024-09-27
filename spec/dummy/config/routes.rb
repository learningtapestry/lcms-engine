# frozen_string_literal: true

Rails.application.routes.draw do
  mount Lcms::Engine::Engine => '/lcms-engine'
  root to: redirect('/lcms-engine/')

  get '/oauth2callback', to: redirect(path: '/lcms-engine/oauth2callback')

  scope 'lcms-engine' do
    resources :documents, only: :show
    resources :materials, only: :show
  end

  get '/admin', to: 'welcome#index', as: :admin
end
