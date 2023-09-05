#!/usr/bin/env bash

gem update --system 3.4.12
gem install bundler:2.4.12

bundle _2.4.12_ install

rbs collection install
rbs collection update

bin/overcommit --sign
if ! GIT_AUTHOR_EMAIL=ci@test.com GIT_AUTHOR_NAME='ci user' bundle exec overcommit --run; then
  exit 1
fi

# Setup environment
echo -e 'APPLICATION_DOMAIN=example.org' > .env
RAILS_ENV="test" bin/rails db:create
RAILS_ENV="test" bin/rails db:schema:load
RAILS_ENV="test" bin/rails db:migrate
