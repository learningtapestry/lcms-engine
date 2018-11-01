# frozen_string_literal: true

# Base interactor to be used on the controllers
# Usage:
#
#   class MyController
#     def my_action
#       interactor = MyInteractor.call(self)
#       if interactor.success?
#           # do something
#       else
#           # use interactor.error
#       end
class BaseInteractor
  def self.call(context)
    interactor = new(context)
    interactor.run
    interactor
  end

  attr_reader :error

  def initialize(context)
    @context = context
  end

  def success?
    @error.nil?
  end

  def run
    raise NotImplementedError
  end

  protected

  attr_reader :context

  def fail!(error)
    @error = error
  end

  def params
    context.params
  end
end
