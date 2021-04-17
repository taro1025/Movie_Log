class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :movie_id
      t.integer :fun
      t.integer :spoiler
      t.integer :user_id
      t.string :title
      t.integer :post_to

      t.timestamps
    end
  end
end
