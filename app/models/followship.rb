class Followship < ApplicationRecord
  #uniqueness 方法在物件儲存前，驗證屬性值是否是唯一的，scope 可用另一個屬性來限制唯一性
  validates :following_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :following, class_name: "User"
end
