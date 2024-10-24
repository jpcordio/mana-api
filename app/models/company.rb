class Company < ApplicationRecord
   belongs_to :user, foreign_key: :company_id

   # Método para buscar a companhia pelo user_id
   def self.find_by_user(user_id)
     where(company_id: user_id).first
   end
 end
