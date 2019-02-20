class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :micropost_id, presence: true
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validate :picture_size
private 

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, 'Should be less than 5mb')
    end
  end
end
