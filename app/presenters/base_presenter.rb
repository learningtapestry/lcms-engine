# frozen_string_literal: true

class BasePresenter < SimpleDelegator
  def initialize(obj, opts = {})
    super(obj)
    opts.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def t(key, options = {})
    class_name = self.class.to_s.underscore
    options[:raise] = true
    if key.starts_with?('.')
      I18n.t("#{class_name}.#{key}", options)
    else
      I18n.t(key, options)
    end
  end
end
