class CreateConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :connections do |t|
      t.integer :customer_id
      t.integer :company_id

      t.timestamps
    end
  end
end
