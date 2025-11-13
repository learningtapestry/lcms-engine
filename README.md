# LCMS Engine

[![Maintainability](https://api.codeclimate.com/v1/badges/9a41f6860cc4531fc27e/maintainability)](https://codeclimate.com/github/learningtapestry/lcms-engine/maintainability)
[![Codeship Status for learningtapestry/lcms-engine](https://app.codeship.com/projects/d08d0660-26f7-0137-bc36-1692d0f2de6b/status?branch=master)](https://app.codeship.com/projects/330483)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

Implements a Rails engine for Learning Content Management System (LCMS) applications.

Our initial goal is gathering the common code among the current LCMS implementations
(Odell, Unbound ED and OpenSciEd) and provide a unified codebase that can be maintained and developed
separately, simplifying the client applications in the process.

## Requirements

- Ruby 3.2.x
- Rails 6.1 or higher
- Postgres 9.6 or higher

## Current development

| Branch    | Rails version |
|-----------|---------------|
| master    | Rails 7.0     |
| rails-6.1 | Rails 6.1     |

## Detailed information

- [Environment variables](docs/env-variables.md)
- [Google Cloud setup](docs/google-cloud-platform-setup.md)
- [Building and publishing](docs/how-to-build-and-publish.md)
- [PDF generation](docs/pdf-generation.md)
- [Override controllers for Rails 7 application](docs/override-controllers-for-rails-7.md)
- [CKEditor usage](docs/ckeditor-usage.md)

## Guidelines

The following are a few recommendations and guidelines to keep in mind when modifying code in the
engine as well as making the client projects aware of these changes.

## Use of separate gems

In our opinion, the creation of separate gems in a given project only makes sense when the features
to be extracted have enough weight to justify a separate development cycle, away from the original
project, and are useful to more than one application at the same time. When that does not happen,
the argument in favor of multiple gems per project becomes less convincing, and the downsides of
this approach - like keeping compatibility with the dependencies or being forced to manage different
versions - are more evident and, thus, make development harder for a minor benefit.

Rails supports, and even encourages, a monolithic approach when developing web applications, so it's
always going to be easier to work with it if you adhere to this type of architecture.

Whenever you're thinking about extracting some piece of code that's only relevant to your project
into a gem, you can consider either moving it to the engine if it's a common LCMS feature that can
potentially be used by other client projects. Otherwise just keep it inside your project; perhaps
in a separate module or namespace so that it does not get tangled with your regular application code.
Creating a new gem is probably not worth the effort and should only be considered in a few specific
cases.

### Override and extension

When the features provided by the engine are not enough in your client application or you need to
perform some kind of customization or improvement, it's important to distinguish the type of asset
you're trying to customize and the volume of the changes involved.

For regular Ruby classes and modules, we suggest sticking to the recommended practices defined in
the official [Rails guide for engines](https://guides.rubyonrails.org/engines.html#improving-engine-functionality)
which, for the most part, use the [Decorator pattern](https://en.wikipedia.org/wiki/Decorator_pattern).

- For small changes or refinements you can create a new decorator class inside the `app/decorators`
folder, and use `class_eval` or `module_eval` to override the methods that you want. You can see a
few examples of this technique in the latest changes added to [OpenSciEd](https://github.com/learningtapestry/openscied-lcms/tree/engine-integration/app/decorators)
and [Odell](https://github.com/learningtapestry/odell-lcms/tree/engine-integration/app/decorators)
- When changes are bigger or have a much larger impact on the target class or module, it's better to
include a new module that contains your overrides. Again, the Rails guide suggests using
`ActiveSupport::Concern`, which simplifies things a bit, although a regular Ruby module would also
work. In this case, you move the default code to a new module that extends `ActiveSupport::Concern`,
and include that resulting module in both the engine class and the one in your client application.
After that, you're free to add new methods or override the ones from the module.
You can see examples of an [extracted module](https://github.com/learningtapestry/lcms-engine/blob/master/lib/concerns/doc_template/template.rb)
and a [class including it](https://github.com/learningtapestry/odell-lcms/blob/engine-integration/lib/doc_template/template.rb).
- Finally, as a last resort, if the customizations you're performing differ a lot from the default
behaviour, you can consider overriding completely the class by just leaving a file with the same
name in the same path. Rails will always give preference to classes inside your project in the
loading phase.

Other kinds of assets, like ERB views, images, stylesheets or javascript files, can not be
overridden as easily as Ruby classes and modules, but you can always provide your own versions of
the same files, overwriting the ones provided by the engine.

TODO: Update this part about how to build the assets
**OUT DATED** You can run the rake task `lcms_engine:webpacker:compile` and set the environment variable `YARN_PATH` to set the yarn binary.

## Installation

Add this to the Gemfile:

```ruby
gem 'lcms-engine'
```

And then execute:

```bash
bundle
```

Copying all required configuration files

```bash
bin/rails g lcms:engine:install
```

You may need to load the schema. Execute from your app's root directory:

```bash
bin/rails lcms_engine:load_default_schema
```

Pre-load required data

```bash
bin/rails lcms_engine:seed_data
```

Mount the engine in the `routes.rb`

```ruby
mount Lcms::Engine::Engine, at: '/lcms'
```

Pay attention that adding route alias is not supported. That said you **can't** mount the engine as follow:

```ruby
mount Engine, at: '/engine', as: :engine
````

Inside environment configuration files explicitly set resque queue adapter and queue prefix if need to separate
queues across environments:

```ruby
# config/environments/development.rb
# config/environments/staging.rb
# ...
# config/environments/production.rb

# Use a real queuing backend for Active Job (and separate queues per environment)
# config.active_job.queue_adapter     = :resque
# config.active_job.queue_name_prefix = "content_#{Rails.env}"
# Explicitly set queue adapter (set the same as at lcms-engine)
config.active_job.queue_adapter = :resque
config.active_job.queue_name_prefix = ''
```

If you need to redefine devise routes set up env `DEVISE_ROUTES_REDEFINED` as true and define devise related routes at host app.

### Host app routes

When host app has its own routes on upper than engine level:

```ruby
Lcms::Engine::Engine.routes.draw do
  devise_for :users, class_name: 'Lcms::Engine::User',
                     router_name: :main_app,
                     skip: %i(sessions registrations passwords)
end

# define scope at host level to avoid engine prefix at routes
devise_scope :user do
  get '/login', to: 'lcms/engine/sessions#new', as: :new_user_session
  post '/login', to: 'lcms/engine/sessions#create', as: :user_session
  get '/logout', to: 'lcms/engine/sessions#destroy', as: :destroy_user_session
  post '/password', to: 'devise/passwords#create', as: :user_password
  get '/password/new', to: 'devise/passwords#new', as: :new_user_password
  get '/password/edit', to: 'devise/passwords#edit', as: :edit_user_password
  patch '/password', to: 'devise/passwords#update'
  put '/password', to: 'devise/passwords#update'
  get '/register/cancel', to: 'lcms/engine/registrations#cancel', as: :cancel_user_registration
  post '/register', to: 'lcms/engine/registrations#create', as: :user_registration
  get '/register/sign_up', to: 'lcms/engine/registrations#new', as: :new_user_registration
  get '/register/edit', to: 'lcms/engine/registrations#edit', as: :edit_user_registration
  patch '/register', to: 'lcms/engine/registrations#edit'
  put '/register', to: 'lcms/engine/registrations#update'
  delete '/register', to: 'lcms/engine/registrations#destroy'
end
```

When host app is ok with `/lcms` devise routes but want to redefine paths after that:

```ruby
Lcms::Engine::Engine.routes.draw do
  devise_for :users, class_name: 'Lcms::Engine::User',
                     controllers: {
                       registrations: 'lcms/engine/registrations',
                       sessions: 'lcms/engine/sessions'
                     },
                     module: 'devise',
                     path: '',
                     path_names: {
                       sign_in: 'login',
                       sign_out: 'logout',
                       password: 'secret',
                       registration: 'register',
                       sign_up:  'sign_up'
                     }
end
```

### Migrations

All migrations included in the gem are already available for you to run from inside host application.

### Using with Host app

You need to run special rake task if default routes were overridden

## Developing and testing

You need to create `/spec/dummy/.env.test` file to be able to use Rails console
inside dummy app.

To be able to to run specs you need to create `/spec/dummy/.env.test` file and add there variables for database
connection (see `spec/dummy/.env` as a template)

`chromedriver` is required to run feature specs. You may find OS-specific instructions [here](https://sites.google.com/a/chromium.org/chromedriver/getting-started).
For macOS it can be installed with Homebrew:

```bash
brew tap homebrew/cask
brew cask install chromedriver
```

### Using Docker

Launch the containers

```shell
docker compose create
docker compose start db redis
docker compose exec db sh -c "psql -U postgres -d template1 -c 'CREATE EXTENSION IF NOT EXISTS hstore;'"
docker compose exec db sh -c "psql -U postgres -c 'CREATE DATABASE lcms_engine_test;'"
docker compose start app
```

Start the specs

```shell
docker compose run --rm app sh -c 'bundle exec rspec'
```

In case you need to rebuild the image, use buildx command to create multi-arch image and push it to the registry

```shell
docker buildx build --platform linux/arm64/v8,linux/amd64 -t learningtapestry/lcms-engine:ruby-3.3.9-rails-8.0 --push .
```

### RBS type checking
To run type checks locally:

```shell
bundle exec steep check
```

To generate RBS files for a new model, go to spec/dummy and run the following command:

```shell
bundle exec rails rbs_rails:generate_rbs_for_models
```

You can then copy the relevant files to the correct sig subdirectory from root, and delete the other non-relevant files
under spec/dummy/sig

To generate a single non-model file signature, follow this example. You may need to manually create the sig subdirectories
if not already there

```shell
bundle exec rbs prototype rb app/jobs/lcms/engine/integrations/webhook_call_job.rb > sig/app/jobs/lcms/engine/integrations/webhook_call_job.rbs
```

## License

The gem is available as open source under the terms of the [Apache License](https://github.com/learningtapestry/lcms-engine/blob/master/LICENSE).
