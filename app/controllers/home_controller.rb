class HomeController < ApplicationController

  def top
    @movies = Movie.all
    @timeline = []
    if @current_user
      if @current_user.following
        @timeline = Post.where(user_id: @current_user.following).order(created_at: "DESC")
      #  @current_user.following.each do |user|
      #    post = Post.where(user_id: user.id)
      #    post.each do |p|
      #      @timeline << p
      #    end
      #  end
      end
    else
      @posts = Post.where(post_to:nil).order("id DESC")
    end

  end


  def signup
    @user = User.new
  end

  def user_create
    @user = User.new(
      name: params[:name], email: params[:email],
      password: params[:password],
      image_name:"default.jpg", header: "default.jpg"
    )
    if @user.save
      flash[:notice] = "登録完了しました。"
      session[:user_id] = @user.id
      redirect_to("/")
    else
      flash[:notice] = "なにか間違えてます。"
      render("home/signup")
    end
  end

  def edit
    @user = User.find_by(id: params[:user_id]) #user_page/:user_idのユーザー
    user = User.find_by(id: @current_user.id)
    user.name = params[:name] if params[:name]
    user.description = params[:description] if params[:description]

    if params[:image]
      #変更前の画像を削除
      begin
        File.delete("public/user_images/#{user.image_name}")
      rescue
        p "feiled to delete file"
      end
      #画像の変更
      user.image_name = "#{@current_user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{user.image_name}", image.read)
    end

    if params[:header]
      #変更前の画像を削除
      begin
        File.delete("public/user_headers/#{user.header}")
      rescue
        p "feiled to delete file"
      end
      #画像の変更
      user.header = "#{@current_user.id}.jpg"
      image = params[:header]
      File.binwrite("public/user_headers/#{user.header}", image.read)
    end

    if user.save
      redirect_to("/user_page/#{@current_user.id}")
    else
      flash[:notice] = "failed"
      @name = params[:name]
      @description = params[:description]
      render("home/user_page")
    end
  end

  def login_form

  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "#{@user.name}さん、こんにちは！"
      redirect_to("/")
    else
      @email = params[:email]
      @password = params[:password]
      @error_message = "Emailまたはパスワードが違います。"
      render("home/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to("/")
  end

  def user_page
    @user = User.find_by(id: params[:user_id])
    @posts = Post.where(user_id: @user.id, post_to: nil)

    movie_length = @posts.count

    @num_of_fun = @posts.where(user_id: @user.id, fun: 1).count
    @num_of_movies = movie_length
    @num_of_likes = Like.where(post_id: @user.posts).count
    @num_of_comments = Post.where(post_to: @user.posts).count

    #userの情報（編集の際に初期値として使いたい)
    @name = @user.name
    @description = @user.description
  end

  def likes_page
    @user = User.find_by(id: params[:user_id])
    @posts = Post.where(user_id: @user.id, post_to: nil)

    liked = Like.where(id_user_pressed_liked: @user).order(created_at: "DESC")
    @liked_posts = []
    liked.each do |like|
      @liked_posts << Post.find_by(id: like.post_id)
    end

    movie_length = @posts.count

    @num_of_fun = @posts.where(user_id: @user.id, fun: 1).count
    @num_of_movies =  movie_length
    @num_of_likes = Like.where(post_id: @user.posts).count
    @num_of_comments = Post.where(post_to: @user.posts).count

    #userの情報（編集の際に初期値として使いたい)
    @name = @user.name
    @description = @user.description
  end

  def notifications
    #posts = @current_user.posts.Likes.exists? update
    #posts.each do {post}
    #post.likes...
    @notifications =  @current_user.passive_notifications

    @notifications.where(checked: false).each do |notification|
      notification.checked = true
      notification.save
    end
  end

 #def tes
#   user = Like.all
#   user.each  {|u| u.destroy}
#   redirect_to("/")
 #end
end
