class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.integer :user_id
      t.string :title
      t.string :genre
      t.string :image_name

      t.timestamps
    end
  end
end
