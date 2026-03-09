class UserBaby < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :birth_date, presence: true
  validates :weight, presence: true
end
