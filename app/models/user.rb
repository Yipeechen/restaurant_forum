class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
    has_many :friendships,dependent: :destroy
    has_many :friends, through: :friendships

  def friend_receiver?(user)
    self.friends.include?(user)
  end

  def following?(user)
    self.followings.include?(user)
  end
  
  def admin?
    self.role == "admin"
  end

end
