class ApplicationController < ActionController::Base

  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
    if @current_user
      @is_notice = @current_user.passive_notifications.
                      where(checked: false).exists?
    end
  end


  GENRE = [
    "SF", "アクション・アドベンチャー", "インタビュー・トークショー", "アニメ",
    "インディーズ・アートハウス", "エクササイズ・フィットネス", "エロス",
    "キッズ・ファミリー", "グルメ", "コメディ", "スポーツ", "ドキュメンタリー",
    "ドラマ", "ハウツー", "ファンタジー", "ホラー", "ミステリー・スリラー",
    "ミリタリー・戦争", "リアリティショー", "ロマンス", "教育",
    "旅行", "科学・テクノロジー", "芸術・娯楽"
  ]
end
