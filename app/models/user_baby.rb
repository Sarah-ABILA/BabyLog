class UserBaby < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  validates :name, presence: true
  validates :birth_date, presence: true
  validates :weight, presence: true

  def age_in_months
    ((Date.today - birth_date.to_date) / 30.44).floor
  end

  def age_label
    months = age_in_months
    if months < 24
      "#{months} mois"
    else
      years = months / 12
      remaining = months % 12
      remaining.positive? ? "#{years} ans et #{remaining} mois" : "#{years} ans"
    end
  end
end
