# frozen_string_literal: true

Rails.application.routes.draw do
  mount Lcms::Engine::Engine => '/lcms-engine'
  root to: redirect('/lcms-engine/')

  # Used for testing only
  direct(:document) { '/' }
  direct(:material) { '/' }

  get '/admin', to: 'welcome#index', as: :admin
end
