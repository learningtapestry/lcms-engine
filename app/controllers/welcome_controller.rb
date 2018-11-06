# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    redirect_to root_path
  end
end
