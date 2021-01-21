# frozen_string_literal: true

Lcms::Engine::Engine.routes.draw do
  mount PdfjsViewer::Rails::Engine, at: '/pdfjs', as: 'pdfjs'

  resources :documents, only: :show do
    member do
      post 'export', to: 'documents#export'
      get 'export/status', to: 'documents#export_status'
      post 'lti', to: 'documents#show_lti'
    end
  end
  resources :materials, only: :show do
    member do
      get 'preview/pdf', to: 'materials#preview_pdf'
      get 'preview/gdoc', to: 'materials#preview_gdoc'
    end
  end
  resources :resources, only: [:show]

  unless ENV.fetch('DEVISE_ROUTES_REDEFINED', false)
    devise_for :users, class_name: 'Lcms::Engine::User',
                       controllers: {
                         registrations: 'lcms/engine/registrations'
                       },
                       module: :devise
  end

  authenticate :user do
    mount Resque::Server, at: '/queue'
  end

  namespace :admin do
    get '/' => 'welcome#index'
    get '/association_picker' => 'association_picker#index'
    resource :resource_bulk_edits, only: %i(new create)
    get '/resource_picker' => 'resource_picker#index'
    resources :resources, except: :show do
      member do
        post :export_to_lti_cc, path: 'export-lti-cc'
        post :bundle
      end
    end
    resources :settings, only: [] do
      patch :toggle_editing_enabled, on: :collection
    end
    resources :users, except: :show do
      post :reset_password, on: :member
    end
    resources :standards, only: %i(index edit update)

    resource :sketch_compiler, path: 'sketch-compiler', only: [] do
      get '/', to: 'sketch_compilers#new', defaults: { version: 'v1' }
      get '/:version/new', to: 'sketch_compilers#new', as: :new
      post '/:version/compile', to: 'sketch_compilers#compile', as: :compile
    end
    resources :documents, except: %i(edit show update) do
      collection do
        delete :delete_selected, to: 'documents#destroy_selected'
        post :reimport_selected
        get :import_status, to: 'documents#import_status'
      end
    end
    resources :materials, except: %i(edit show update) do
      collection do
        delete :delete_selected, to: 'materials#destroy_selected'
        post :reimport_selected
        get :import_status, to: 'materials#import_status'
      end
    end
    resource :curriculum, only: %i(edit update)
    resources :access_codes, except: :show
    resource :batch_reimport, only: %i(new create)
  end

  get '/*slug' => 'resources#show', as: :show_with_slug

  root to: 'welcome#index'
end
