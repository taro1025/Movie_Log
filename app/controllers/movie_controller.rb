class MovieController < ApplicationController
  def search
    @searched_movie = Movie.where("title like ?", "%#{params[:title]}%")
  end


  def mobile_search

  end

  def mobile_manager
    @user = User.find_by(id: params[:user_id])
    @posts = Post.where(user_id: @user.id, post_to: nil)
    @movies = []

    @posts.each do |post|
      @movies << Movie.find_by(id: post.movie_id)
    end

    @num_of_fun = @posts.where(user_id: @user.id, fun: 1).count
    @num_of_movies = @movies.length
    @num_of_likes = Like.where(post_id: @user.posts).count
    @num_of_comments = Post.where(post_to: @user.posts).count

  end

  def create_form
    @genre = GENRE
  end

  def add
    movie = Movie.create(title: params[:title])

    if params[:movie_image]
      movie.image_name = "#{movie.id}.jpg"
      movie_image = params[:movie_image]
      File.binwrite("public/movie_images/#{movie.image_name}", movie_image.read)
    else
      movie.image_name = "default.jpg"
    end

    #GenreMovieへ記録。ここリファクタリングできそう。
    if params[:genre1]
      genre1 = GenreMovie.new
      genre1.movie_id = movie.id
      genre1.genre = params[:genre1]
    end
    if params[:genre2]
      genre2 = GenreMovie.new
      genre2.movie_id = movie.id
      genre2.genre = params[:genre2]
    end

    movie.save
    genre1.save
    genre2.save

    redirect_to("/")
  end

  def add_watch_list
    if @current_user.watch_lists.create(movie_id: params[:movie_id])
      redirect_back(fallback_location: "/")
    else
      redirect_back(fallback_location: "/")
    end
  end
end
