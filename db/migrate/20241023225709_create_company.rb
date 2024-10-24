class CreateCompany < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.references :company, null: false, foreign_key: { to_table: :users }
      t.string :address1
      t.string :address2
      t.string :city
      t.string :county
      t.string :postcode
      t.string :country
      t.string :phone
      t.string :mobile
      t.string :website
      t.string :email

      t.timestamps
    end
  end
end
