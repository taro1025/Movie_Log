class PostController < ApplicationController
  def index
    @movie_id = params[:id]
    @posts = Post.where(movie_id: @movie_id, post_to: nil)
  end

  def post

    #renderするときindexで必要なデータ
    @movie_id = params[:id]
    @posts = Post.all

    #非会員の誘導
    unless @current_user
      @title = params[:title]
      @content = params[:content]
      @fun = params[:fun]
      @spoiler = params[:spoiler]
      @error_message = "無料会員登録が必要です"
      render("post/index")
    else
      post = Post.new(
        title: params[:title], content: params[:content],
        fun: params[:fun], spoiler: params[:spoiler],
        user_id: @current_user.id, movie_id: params[:id]
      )

      if post.save
        redirect_to("/posts/#{params[:id]}")
      else
        @title = params[:title]
        @content = params[:content]
        @fun = params[:fun]
        @spoiler = params[:spoiler]
        @error_message = "感想は必須項目です。"
        render("post/index")
      end
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comments = Post.where(post_to: params[:id])
  end

  #post（感想)へのコメント
  def comment

    #render用
    @text = params[:comment]
    @comments = Post.where(post_to: params[:id])
    @post = Post.find_by(id: params[:id])


    #非会員の誘導
    unless @current_user
      @error_message = "無料会員登録が必要です"
      render("post/show")
    else
      @comment = Post.new(
        content: params[:comment], user_id: @current_user.id,
        movie_id: @post.movie_id, post_to: @post.id
      )
      if @comment.save && params[:comment]
        @current_user.create_notification_comment!( @comment.id, @post.id, @post.user_id)
        redirect_to("/posts/show/#{params[:id]}")
      else
        @error_message = "コメントを書いてください。"
        render("post/show")
      end
    end
  end

  #コメントへのコメント
  def new_response

    #以下３つはrender先用
    @comments = Post.where(post_to: params[:id])
    @comment_to_commented = Post.find_by(id: params[:id])
    @text = params[:comment]

    @thred = []
    highest_post = @comment_to_commented
    while highest_post.post_to do
      highest_post = Post.find_by(id:highest_post.post_to)
      @thred << highest_post
    end

    if @current_user
      #通常処理
      comment = Post.new(
        content: params[:comment], post_to: params[:id],
         user_id: @current_user.id, movie_id: @comment_to_commented.movie_id
      )

      if comment.save && params[:comment]
        redirect_to("/comments/#{params[:id]}") #コメントが主のスレッド
      else
        @error_message = "コメントを書いてください。"
        render("post/comments")
      end
    else
      #非会員へ登録の誘導
      @error_message = "無料会員登録が必要です"
      render("post/comments")
    end
  end

  def comments
    @comments = Post.where(post_to: params[:id])
    @comment_to_commented = Post.find_by(id: params[:id])

    @thred = []
    highest_post = @comment_to_commented
    while highest_post.post_to do
      highest_post = Post.find_by(id:highest_post.post_to)
      @thred << highest_post
    end
  

  end
end
