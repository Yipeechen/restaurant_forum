class Restaurant < ApplicationRecord
    validates_presence_of :name

    mount_uploader :image, PhotoUploader
    belongs_to :category, optional: true

    has_many :comments, dependent: :destroy

    # 「餐廳被很多使用者收藏」的多對多關聯
    has_many :favorites, dependent: :destroy
    has_many :favorited_users, through: :favorites, source: :user

    def is_favorited?(user)
      self.favorited_users.include?(user)
    end
    
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user

end
