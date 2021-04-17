class CreateGenreMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :genre_movies do |t|
      t.string :genre
      t.integer :movie_id

      t.timestamps
    end
  end
end
