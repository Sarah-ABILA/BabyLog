class Vaccination < ApplicationRecord
  #  l'ID s'appelle baby_id mais cherche dans UserBaby
  belongs_to :user_baby, class_name: "UserBaby", foreign_key: "user_baby_id"

  #def due_date
  # Sécurité : si l'âge est nil, on considère 0 mois
 # months_to_add = age || 0

  # On s'assure que user_baby et sa birth_date existent
  #if user_baby&.birth_date
   # user_baby.birth_date + months_to_add.months
 #else
   # Date.today
  #end
#end
#
 def date_for_age(age_in_months)
    birth_date + age_in_months.months
  end

  def urgent?
    !status && due_date < Date.today
  end

  scope :done, -> { where(status: true) }
  scope :pending, -> { where(status: false) }
end
