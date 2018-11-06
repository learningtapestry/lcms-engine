# frozen_string_literal: true

module Admin
  class GoogleOauth2Controller < AdminController
    skip_before_action :authenticate_admin!

    def callback
      redirect_to Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    end
  end
end
