# frozen_string_literal: true

module PagesHelper
  def standardsinstitutes_link
    @standardsinstitutes_link ||= link_to(
      t('ui.learn_more'),
      'http://www.standardsinstitutes.org/',
      class: 'o-btn o-btn--register o-btn--xs-full u-margin-bottom--zero', target: '_blank'
    )
  end
end
