class Connection < ApplicationRecord
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :company, class_name: 'User', foreign_key: 'company_id'

  # Ensure that customer can't follow the same company twice
  validates :customer_id, uniqueness: { scope: :company_id, message: "You are already following this company." }

  # Block to connect to itself and ensure to connect only to a company
  validate :cannot_connect_to_self, :must_connect_to_company

  private

  def cannot_connect_to_self
    errors.add(:company, "You cannot follow yourself.") if customer_id == company_id
  end

  def must_connect_to_company
    errors.add(:company, "You can only follow companies.") unless company&.company?
  end
end
