class User < ApplicationRecord
  #Relationship
  has_many :active_relationships, class_name:  "Relationship",
                                foreign_key: "follower_id",
                                dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                foreign_key: "followed_id",
                                dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower


  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  validates :password, {presence: true, length: {maximum:30}}
  validates :name, {presence: true, length: {maximum: 50}}
  validates :email, {presence: true, uniqueness: true}
  validates :description, {length: {maximum: 160}}

  #WatchList
  has_many :watch_lists, dependent: :destroy

  #Post
  has_many :posts, dependent: :destroy


  #Notification
  has_many :active_notifications, class_name: 'Notification',
                               foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification',
                               foreign_key: 'visited_id', dependent: :destroy

  def create_notification_follow!( other_user_id)
    temp = Notification.where(
      ["visitor_id = ? and visited_id = ? and action = ? ",
        id, other_user_id, 'follow']
      )
    if temp.blank?
      notification = active_notifications.new(
        visited_id: other_user_id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end



  def create_notification_comment!(comment_id, post_id, visited_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    #temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    #temp_ids.each do |temp_id|
    #  save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    #end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    #save_notification_comment!(current_user, comment_id, user_id) #if temp_ids.blank?

    notification = active_notifications.new(
      post_id: post_id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?

  end
end
