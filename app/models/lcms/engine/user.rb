# frozen_string_literal: true

require 'devise'

module Lcms
  module Engine
    class User < ApplicationRecord
      # Include default devise modules. Others available are:
      # :lockable, :timeoutable and :omniauthable
      devise :database_authenticatable, :registerable, :confirmable,
             :recoverable, :rememberable, :trackable, :validatable

      enum :role, { admin: 1, user: 0 }

      validates_presence_of :access_code, on: :create, unless: :admin?
      validates_presence_of :email, :role
      validate :access_code_valid?, on: :create, unless: :admin?

      def generate_password
        pwd = Devise.friendly_token.first(20)
        self.password = pwd
        self.password_confirmation = pwd
      end

      private

      def access_code_valid?
        return false if AccessCode.by_code(access_code.to_s).exists?

        errors.add :access_code, 'not found'
      end

      protected

      # NOTE: temporary disable confirmable due to issues with server setup
      def confirmation_required?
        false
      end
    end
  end
end
