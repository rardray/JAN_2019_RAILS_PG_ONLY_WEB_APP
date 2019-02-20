class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :micropost_id, presence: true
  default_scope -> {order(created_at: :desc)}
end
