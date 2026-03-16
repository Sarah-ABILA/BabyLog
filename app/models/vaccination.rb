class Vaccination < ApplicationRecord
  #  l'ID s'appelle baby_id mais cherche dans UserBaby
  belongs_to :user_baby, class_name: "UserBaby", foreign_key: "user_baby_id"

  scope :done, -> { where(status: true) }
  scope :pending, -> { where(status: false) }
end
