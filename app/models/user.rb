class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    #Case 1: Find existing user by facebook uid
    # User不是第一次用FB登入：可以用fb_uid找到現存User
    user = User.find_by_fb_uid(auth.uid)
    if user
      user.fb_token = auth.credentials.token
      user.save!
      return user
    end

    #Case 2: Find existing user by email
    # User是第一次用FB登入，但是也是用同一組信箱帳號註冊過，就可以拿出FB回傳的email，從資料庫搜尋現存的User
    existing_user = User.find_by_email(auth.info.email)
    if existing_user
      existing_user.fb_uid = auth.uid
      existing_user.fb_token = auth.credentials.token
      existing_user.save!
      return existing_user
    end


    #Case 3: Create new password
    # User沒有註冊過，且是第一次用FB登入，故需創建一個全新的User紀錄
    user = Use.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.save!
    return user
  end

  validates_presence_of :name
  mount_uploader :avatar, AvatarUploader

  has_many :comments, dependent: :restrict_with_error
  has_many :restaurants, through: :comments

  # 「使用者收藏很多餐廳」的多對多關聯
  has_many :favorites, dependent: :destroy
  has_many :favorited_restaurants, through: :favorites, source: :restaurant

  has_many :likes, dependent: :destroy
  has_many :liked_restaurants, through: :likes, source: :restaurant

  # 「使用者追蹤很多使用者」
  has_many :followships, dependent: :destroy
  has_many :followings, through: :followships

  # 「使用者的追蹤者」
  has_many :inverse_followships, class_name: "Followship", foreign_key: "following_id"
  has_many :followers, through: :inverse_followships, source: :user

  #「使用者新增很多朋友」
  has_many :friendships, -> {where status: true}, dependent: :destroy
  has_many :friends, through: :friendships

  #「使用者的朋友邀請」
  has_many :inverse_friendships, -> {where status: true}, class_name: "Friendship", foreign_key:"friend_id"
  has_many :inviters, through: :inverse_friendships, source: :user

  has_many :unconfirm_friendships, -> {where status: false}, class_name: "Friendship", dependent: :destroy
  has_many :unconfirm_friends, through: :unconfirm_friendships, source: :friend
  has_many :request_friendships, -> {where status: false}, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :request_friends, through: :request_friendships, source: :user

  def friend_receiver?(user)
    self.friends.include?(user) || self.inviters.include?(user)
  end

  def unconfirm_friend?(user)
    self.unconfirm_friends.include?(user)
  end

  def all_friends
    friends = self.friends + self.inviters
    return friends.uniq
  end

  def following?(user)
    self.followings.include?(user)
  end
  
  def admin?
    self.role == "admin"
  end

end
