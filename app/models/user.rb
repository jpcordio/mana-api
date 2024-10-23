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

  # Relationships for customers (users with role = false)
  has_many :connections_as_customer, class_name: 'Connection', foreign_key: 'customer_id'
  has_many :followed_companies, through: :connections_as_customer, source: :company
  has_many :companies_as_customer, through: :connections_as_customer, source: :company

  # Relationships for companies (users with role = true)
  has_many :connections_as_company, class_name: 'Connection', foreign_key: 'company_id'
  has_many :followers, through: :connections_as_company, source: :customer



  # Métodos para verificar se o usuário é uma company ou um customer
  def company?
    self.role == true
  end

  def customer?
    self.role == false
  end


  validates :role, inclusion: { in: [true, false] }
  validates :name, presence: true, unless: :resetting_password?

  def resetting_password?
    self.reset_password_token.present?
  end

end
