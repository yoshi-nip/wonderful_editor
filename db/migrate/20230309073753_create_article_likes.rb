class CreateArticleLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :article_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :articles, null: false, foreign_key: true

      t.timestamps
    end
  end
end
