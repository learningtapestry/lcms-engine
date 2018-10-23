# frozen_string_literal: true

module Lcms
  module Engine
    # Main application mailer
    class ApplicationMailer < ActionMailer::Base
      default from: 'from@example.com'
      layout 'mailer'
    end
  end
end
