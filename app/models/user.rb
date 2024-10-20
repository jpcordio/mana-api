# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :confirmable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :articles, dependent: :destroy

  validates :role, inclusion: { in: [true, false] }
  validates :name, presence: true, unless: :resetting_password?

  def resetting_password?
    self.reset_password_token.present?
  end

end
