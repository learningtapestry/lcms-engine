# Override controllers for Rails 7 application

In case to override controllers in Rails 7 application, you should use the following approach:

1. Create a new module under your application's namespace.
2. List the required query attributes in the module. Do not miss the `#prepend` call at the end of the file.
3. Those attributes will be automatically handled by `Lcms::Engine::Queryable` module.

```ruby
# app/decorators/my_app/lcms/engine/admin/documents_controller_decorator.rb

module MyApp
  module Lcms
    module Engine
      module Admin
        module DocumentsControllerDecorator
          QUERY_ATTRS = %i(
            attribute1,
            attribute2
          ).freeze
          QUERY_ATTRS_NESTED = {
            grades: []
          }.freeze
          QUERY_ATTRS_KEYS = QUERY_ATTRS + QUERY_ATTRS_NESTED.keys

          def self.prepended(base)
            base.send(:remove_const, :QUERY_ATTRS) if base.const_defined?(:QUERY_ATTRS)
            base.send(:remove_const, :QUERY_ATTRS_NESTED) if base.const_defined?(:QUERY_ATTRS_NESTED)
            base.send(:remove_const, :QUERY_ATTRS_KEYS) if base.const_defined?(:QUERY_ATTRS_KEYS)
            base.const_set(:QUERY_ATTRS, QUERY_ATTRS)
            base.const_set(:QUERY_ATTRS_NESTED, QUERY_ATTRS_NESTED)
            base.const_set(:QUERY_ATTRS_KEYS, QUERY_ATTRS_KEYS)
          end
        end
      end
    end
  end
end

Lcms::Engine::Admin::DocumentsController.prepend(MyApp::Lcms::Engine::Admin::DocumentsControllerDecorator)
```
