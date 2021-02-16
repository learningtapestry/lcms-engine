# frozen_string_literal: true

Rails.application.routes.draw do
  get '/404'          => 'pages#not_found'
  get '/about'        => 'pages#show_slug', slug: 'about'
  get '/about/people' => 'pages#show_slug', slug: 'about_people'
  get '/tos'          => 'pages#show_slug', slug: 'tos',     as: :tos_page
  get '/privacy'      => 'pages#show_slug', slug: 'privacy', as: :privacy_page
  get '/forthcoming'  => 'pages#forthcoming'

  get '/search' => 'search#index'

  mount PdfjsViewer::Rails::Engine, at: '/pdfjs', as: 'pdfjs'

  resources :downloads, only: [:show] do
    member do
      get :preview
    end
  end
  get '/downloads/:id/pdf_proxy(/:s3)',
      as: :pdf_proxy_download, to: 'downloads#pdf_proxy', constraints: { s3: %r{[^\/]+} }
  resources :explore_curriculum, only: %i(index show)
  resources :enhance_instruction, only: :index
  resources :find_lessons, only: :index
  resources :pages, only: :show
  resources :resources, only: :show do
    get :pdf_proxy, on: :collection, path: 'pdf-proxy'
  end
  resource :survey, only: %i(create show)

  get '/resources/:id/related_instruction' => 'resources#related_instruction', as: :related_instruction
  get '/media/:id' => 'resources#media', as: :media
  get '/other/:id' => 'resources#generic', as: :generic

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

  devise_for :users, class_name: 'User', controllers: { registrations: 'registrations', sessions: 'sessions' }

  authenticate :user do
    mount Resque::Server, at: '/queue'
  end

  namespace :admin do
    get '/' => 'welcome#index'
    get 'google_oauth2_callback' => 'google_oauth2#callback'
    get '/association_picker' => 'association_picker#index'
    resources :reading_assignment_texts
    resource :resource_bulk_edits, only: %i(new create)
    get '/resource_picker' => 'resource_picker#index'
    resources :resources, except: :show do
      member do
        post :export_to_lti_cc, path: 'export-lti-cc'
        post :bundle
      end
    end
    resources :pages, except: :show
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

  get '/ExcludeMeGA' => 'analytics_exclusion#exclude'

  get '/*slug' => 'resources#show', as: :show_with_slug

  root to: 'welcome#index'
end
