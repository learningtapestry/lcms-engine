# frozen_string_literal: true

class BasePresenter < SimpleDelegator
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
