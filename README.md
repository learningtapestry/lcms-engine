# LCMS Engine

[![Maintainability](https://api.codeclimate.com/v1/badges/9a41f6860cc4531fc27e/maintainability)](https://codeclimate.com/github/learningtapestry/lcms-engine/maintainability)
[![Codeship Status for learningtapestry/lcms-engine](https://app.codeship.com/projects/d08d0660-26f7-0137-bc36-1692d0f2de6b/status?branch=master)](https://app.codeship.com/projects/330483)

Implements a Rails engine for Learning Content Management System (LCMS) applications.

Our initial goal is gathering the common code among the current LCMS implementations
(Odell, Unbound ED and OpenSciEd) and provide a unified codebase that can be maintained and developed
separately, simplifying the client applications in the process.

## Current development

|Branch|Rails version|
|------|-------------|
|master|Rails 5.2.4.2|
|0.1.x|Rails 4.2.11|

This is still a [work in progress](https://github.com/learningtapestry/lcms-engine/issues/3). The
initial phase of the project consisted in extracting as much code as possible from the client
projects and set the engine as the core foundation for further development and optimizations.

Once the integrations with the client projects are successful, phase 1 will be complete and we'll be
able to start phase 2, which ideally should involve optimizing the code and giving the engine some
default features and customization possibilities. This should allow any Rails application to use a
basic LCMS that works out of the box just by including the gem and setting some configuration
options.

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

* For small changes or refinements you can create a new decorator class inside the `app/decorators`
folder, and use `class_eval` or `module_eval` to override the methods that you want. You can see a
few examples of this technique in the latest changes added to [OpenSciEd](https://github.com/learningtapestry/openscied-lcms/tree/engine-integration/app/decorators)
and [Odell](https://github.com/learningtapestry/odell-lcms/tree/engine-integration/app/decorators)
* When changes are bigger or have a much larger impact on the target class or module, it's better to
include a new module that contains your overrides. Again, the Rails guide suggests using
`ActiveSupport::Concern`, which simplifies things a bit, although a regular Ruby module would also
work. In this case, you move the default code to a new module that extends `ActiveSupport::Concern`,
and include that resulting module in both the engine class and the one in your client application.
After that, you're free to add new methods or override the ones from the module.
You can see examples of an [extracted module](https://github.com/learningtapestry/lcms-engine/blob/master/lib/concerns/doc_template/template.rb)
and a [class including it](https://github.com/learningtapestry/odell-lcms/blob/engine-integration/lib/doc_template/template.rb).
* Finally, as a last resort, if the customizations you're performing differ a lot from the default
behaviour, you can consider overriding completely the class by just leaving a file with the same
name in the same path. Rails will always give preference to classes inside your project in the
loading phase.

Other kinds of assets, like ERB views, images, stylesheets or javascript files, can not be
overridden as easily as Ruby classes and modules, but you can always provide your own versions of
the same files, overwriting the ones provided by the engine.

## Requirements
- Ruby 2.5 or higher
- Rails 5.2.4 or higher
- Postgres 9.6 or higher

## Installation
Add this to the Gemfile:
```ruby
source 'https://rails-assets.org' do
  gem 'rails-assets-classnames', '~> 2.2.5'
  gem 'rails-assets-es6-promise', '~> 4.2.4'
  gem 'rails-assets-eventemitter3', '~> 3.1.2'
  gem 'rails-assets-fetch', '~> 3.0.0'
  gem 'rails-assets-jstree', '~> 3.3.8'
  gem 'rails-assets-knockout', '~> 3.5.0'
  gem 'rails-assets-lodash', '~> 4.17.15'
  gem 'rails-assets-selectize', '~> 0.12.6'
end
gem 'lcms-engine', git: 'https://github.com/learningtapestry/lcms-engine.git', branch: 'master'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install lcms-engine
```

Copying all required configuration files
```bash
$ bundle exec rails g lcms:engine:install
```

You may need to load the schema. Execute from your app's root directory:
```bash
$ bundle exec rake lcms_engine:load_default_schema
```

Pre-load required data
```bash
$ bundle exec rake lcms_engine:seed_data
```

Mount the engine in the `routes.rb`
```ruby
mount Lcms::Engine::Engine, at: '/lcms'
```
Pay attention that adding route alias is not supported. That said you **can't** mount the engine as follow:
```ruby
mount Engine, at: '/engine', as: :engine
````

If you need to redefine devise routes set up env `DEVISE_ROUTES_REDEFINED` as true and define devise related routes at host app.

Host app routes examples:
1. host app will have own routes on upper than engine level:
```
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
2. host app is ok with `/lcms` devise routes but want to redefine paths after that:
```
Lcms::Engine::Engine.routes.draw do
  devise_for :users, class_name: 'Lcms::Engine::User',
                     controllers: {
                       registrations: 'lcms/engine/registrations',
                       sessions: 'lcms/engine/sessions'
                     },
                     module: :devise,
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
```bash
$ bundle exec rake js-routes:generate
```

## Developing and testing

You need to create `/spec/dummy/.env.test` file to be able to use Rails console
inside dummy app.

To be able to to run specs you need to create `/spec/dummy/.env.test` file and add there variables for database
connection (see `spec/dummy/.env` as a template)

`chromedriver` is required to run feature specs. You may find OS-specific instructions [here](https://sites.google.com/a/chromium.org/chromedriver/getting-started).
For macOS it can be installed with Homebrew:

```bash
$ brew tap homebrew/cask
$ brew cask install chromedriver
```

#### Using Docker

Launch the containers
```sh
$ docker-compose start app
```

Start the specs
```sh
$ docker-compose exec app sh -c 'bundle exec rspec'
```


## License
The gem is available as open source under the terms of the [Apache License](https://github.com/learningtapestry/lcms-engine/blob/master/LICENSE).
