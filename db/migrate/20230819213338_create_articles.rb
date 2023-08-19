class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title, limit: 256
      t.string :languages

      t.timestamps
    end
  end
end
