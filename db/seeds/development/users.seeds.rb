# frozen_string_literal: true

Lcms::Engine::User
  .create_with(name: 'Admin', password: 'password').find_or_create_by!(email: 'admin@example.org', role: 1)
