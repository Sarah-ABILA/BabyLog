class UserBaby < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  
  validates :name, presence: true
  validates :birth_date, presence: true
  validates :weight, presence: true
end
