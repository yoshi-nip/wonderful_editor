class DropNonUser < ActiveRecord::Migration[6.1]
  def change
    drop_table :article_likes
    drop_table :articles
  end
end
