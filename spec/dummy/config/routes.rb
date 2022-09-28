# frozen_string_literal: true

Rails.application.routes.draw do
  mount Lcms::Engine::Engine => '/lcms-engine'
  root to: redirect('/lcms-engine/')

  get '/oauth2callback', to: redirect(path: '/lcms-engine/oauth2callback')

  # Used for testing only
  direct(:document) { '/' }
  direct(:material) { '/' }

  get '/admin', to: 'welcome#index', as: :admin
end
