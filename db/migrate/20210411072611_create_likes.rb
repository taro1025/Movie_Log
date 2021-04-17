class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :post_id
      t.integer :id_user_pressed_liked
      t.integer :movie_id

      t.timestamps
    end
  end
end
