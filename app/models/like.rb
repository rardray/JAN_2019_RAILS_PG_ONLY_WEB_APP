class Like < ApplicationRecord
  belongs_to :micropost
  belongs_to :user

  private

 
end
