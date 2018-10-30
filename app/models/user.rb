# frozen_string_literal: true

class User < Lcms::Engine::ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { admin: 1, user: 0 }

  validates_presence_of :access_code, on: :create, unless: 'admin?'
  validates_presence_of :email, :role
  validate :access_code_valid?, on: :create, unless: 'admin?'

  def full_name
    [
      survey&.fetch('first_name', nil),
      survey&.fetch('last_name', nil)
    ].reject(&:blank?).join(' ')
  end

  def generate_password
    pwd = Devise.friendly_token.first(20)
    self.password = pwd
    self.password_confirmation = pwd
  end

  def name
    super.presence || full_name
  end

  def ready_to_go?
    admin? || survey.present?
  end

  private

  def access_code_valid?
    return if AccessCode.by_code(access_code).exists?
    errors.add :access_code, 'not found'
  end

  protected

  # NOTE: temporary disable confirmable due to issues with server setup
  def confirmation_required?
    false
  end
end
