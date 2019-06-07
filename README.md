# LCMS Engine

[![Maintainability](https://api.codeclimate.com/v1/badges/9a41f6860cc4531fc27e/maintainability)](https://codeclimate.com/github/learningtapestry/lcms-engine/maintainability)
[![Codeship Status for learningtapestry/lcms-engine](https://app.codeship.com/projects/d08d0660-26f7-0137-bc36-1692d0f2de6b/status?branch=master)](https://app.codeship.com/projects/330483)

Implements a Rails engine for Learning Content Management System (LCMS) applications.

Our initial goal is gathering the common code among the current LCMS implementations
(Odell, Unbound ED and OpenSciEd) and provide a unified codebase that can be maintained and developed
separately, simplifying the client applications in the process.

## Current development

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

## Targeting Rails versions

For the most part, the engine targets Rails version 5, but it's also compatible with version 4.2.

So far, we have not encountered any major obstacles to guarantee compatibility with both versions,
but in some cases we can all agree that total compatibility can be difficult to achieve.

Overall, it's fine to add a few conditionals here and there to check the running version of the
framework, like [in this case](https://github.com/learningtapestry/lcms-engine/blob/master/lib/lcms/engine/migration.rb).
However, when you feel you're adding too many conditionals, perhaps it's time to consider creating
specific versions that cater to individual Rails releases.

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
- Rails 4.2 or higher
- Postgres 9.6 or higher

## Installation
Include the gem in your Gemfile:

```ruby
gem 'lcms-engine'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install lcms-engine
```

You may need to load the schema. Execute from your app's root directory:
```bash
$ bundle exec rake lcms_engine:load_default_schema
```

Pre-load required data
```bash
$ bundle exec rake lcms_engine:seed_data
```

### Migrations

All migrations included in the gem are already available for you to run from inside host application.

## Developing and testing

You need to create `/spec/dummy/.env.test` file to be able to use Rails console
inside dummy app.

To be able to to run specs you need to create `/spec/dummy/.env.test` file and add there variables for database
connection (see `spec/dummy/.env` as a template)

`chromedriver` is required to run feature specs. You may find OS-specific instructions [here](https://sites.google.com/a/chromium.org/chromedriver/getting-started).
For macOS it can be installed with Homebrew:

```sh
brew tap homebrew/cask
brew cask install chromedriver
```

## License
The gem is available as open source under the terms of the [Apache License](https://github.com/learningtapestry/lcms-engine/blob/master/LICENSE).
