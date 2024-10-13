class RenameTitlleToTitle < ActiveRecord::Migration[6.1]
  def change
    rename_column :articles, :titlle, :title
  end
end
