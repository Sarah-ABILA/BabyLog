class UserBaby < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
 

  validates :name, presence: true
  validates :birth_date, presence: true
  validates :weight, presence: true
end
