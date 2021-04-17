class RelationshipController < ApplicationController
  def follow
    user = User.find_by(id: params[:user_id])
    @current_user.follow(user)
    @current_user.create_notification_follow!(user.id)
    redirect_back(fallback_location: "/")
  end

  def unfollow
    user = User.find_by(id: params[:user_id])
    @current_user.unfollow(user.id)
    redirect_back(fallback_location: "/")
  end
end
