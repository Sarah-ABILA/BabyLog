class Vaccination < ApplicationRecord
  #  l'ID s'appelle baby_id mais cherche dans UserBaby
  belongs_to :user_baby, class_name: "UserBaby", foreign_key: "user_baby_id"
 VACCINES_LIST = [
    { name: "BCG (tuberculose)",        age: 0   },
    { name: "Hépatite B - dose 1",      age: 0   },
    { name: "DTCaP-Hib-HB - dose 1",   age: 2   },
    { name: "Pneumocoque - dose 1",     age: 2   },
    { name: "Méningocoque B - dose 1",  age: 2   },
    { name: "Rotavirus - dose 1",       age: 2   },
    { name: "DTCaP-Hib-HB - dose 2",   age: 4   },
    { name: "Pneumocoque - dose 2",     age: 4   },
    { name: "Méningocoque B - dose 2",  age: 4   },
    { name: "Rotavirus - dose 2",       age: 4   },
    { name: "Méningocoque C - dose 1",  age: 5   },
    { name: "DTCaP-Hib-HB - dose 3",   age: 11  },
    { name: "Pneumocoque - dose 3",     age: 11  },
    { name: "ROR - dose 1",             age: 12  },
    { name: "Méningocoque C - dose 2",  age: 12  },
    { name: "ROR - dose 2",             age: 16  },
    { name: "DTCaP - rappel 6 ans",     age: 72  },
    { name: "DTCaP - rappel ado",       age: 132 }
  ].freeze

 def date_for_age(age_in_months)
    birth_date + age_in_months.months
  end

  def urgent?
    !status && due_date < Date.today
  end

  scope :done, -> { where(status: true) }
  scope :pending, -> { where(status: false) }
end
