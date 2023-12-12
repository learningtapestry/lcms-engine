#!/usr/bin/env bash

gem install bundler:2.4.22
gem update --system 3.3.5
bundle _2.4.22_ install

bin/overcommit --sign
if ! GIT_AUTHOR_EMAIL=ci@test.com GIT_AUTHOR_NAME='ci user' bundle exec overcommit --run; then
  exit 1
fi

# Setup environment
echo -e 'APPLICATION_DOMAIN=example.org' > .env
RAILS_ENV="test" bin/rails db:create
RAILS_ENV="test" bin/rails db:schema:load
RAILS_ENV="test" bin/rails db:migrate
