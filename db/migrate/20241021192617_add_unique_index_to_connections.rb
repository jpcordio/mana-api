class AddUniqueIndexToConnections < ActiveRecord::Migration[6.1]
  def change
    add_index :connections, [:customer_id, :company_id], unique: true
  end
end
