class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :titlle
      t.text :body
      t.string :image

      t.timestamps
    end
  end
end
