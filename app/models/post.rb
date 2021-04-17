class Post < ApplicationRecord
  has_many :likes, dependent: :destroy, foreign_key: 'post_id'
  belongs_to :user, optional: true

  has_many :notifications, dependent: :destroy
  has_many :comments_notifications, class_name: 'Notification',
                          foreign_key: 'comment_id',
                          dependent: :destroy


  #validates :content,{presence: true}
  validates :user_id,{presence: true}
  default_scope -> { order(created_at: :desc) }


  def create_notification_like!(current_user,user_id, post_id)
  # いいねされていない場合のみ、通知レコードを作成
  #いいねボタンを連打した場合、押した数だけ相手に通知がいってしまいます。
    if Notification.where(visitor_id: current_user ,visited_id: user_id,
                    post_id: post_id, action:'like').blank?
      notification = current_user.active_notifications.new(
        post_id: post_id,
        visited_id: user_id,
        action: 'like'
      )
    # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end



end
