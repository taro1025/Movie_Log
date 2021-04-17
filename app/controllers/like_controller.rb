class LikeController < ApplicationController
  def create
    like = Like.new(id_user_pressed_liked: @current_user.id,
       post_id: params[:post_id]
     )
    like.save
    post = Post.find_by(id: params[:post_id])
    post.create_notification_like!(@current_user,
                                    post.user_id,  params[:post_id])
    redirect_back(fallback_location: "/")
    #redirect_to("/posts/#{post.movie_id}")
  end

  def destroy

    like = Like.find_by(id_user_pressed_liked: @current_user.id,
       post_id: params[:post_id]
     )
    like.destroy
    redirect_back(fallback_location: "/")
  end
end
