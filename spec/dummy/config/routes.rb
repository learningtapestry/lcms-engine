# frozen_string_literal: true

Rails.application.routes.draw do
  mount Lcms::Engine::Engine => '/lcms-engine'
end
