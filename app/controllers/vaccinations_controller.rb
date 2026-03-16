class VaccinationsController < ApplicationController
  before_action :authenticate_user!

  # def index
  #   @babies = current_user.user_babies.order(:name)
  #   @selected_baby = params[:baby_id].present? ? @babies.find_by(id: params[:baby_id]) : @babies.first

  #   # Si pas de bébé, on arrête là
  #   return unless @selected_baby

  #   # On crée les vaccins s'ils n'existent pas
  #   VACCINES_LIST.each do |vac|
  #     @selected_baby.vaccinations.find_or_create_by!(name: vac[:name]) do |v|
  #       v.status = false
  #     end
  #   end

  #   # On les trie et on les groupe
  #   @vaccinations_by_age = @selected_baby.vaccinations
  #     .group_by { |v| age_label_for(v.name) }

  #   @done_count = @selected_baby.vaccinations.done.count
  #   @pending_count = @selected_baby.vaccinations.pending.count
  # end
def index
  @babies = current_user.user_babies.order(:name)

  # Si l'utilisateur a des bébés, on gère la sélection
  if @babies.any?
    @selected_baby = params[:baby_id].present? ? @babies.find_by(id: params[:baby_id]) : @babies.first

    # Sécurité : on ne crée les vaccins que si on a bien trouvé un bébé
    if @selected_baby
      VACCINES_LIST.each do |vac|
        @selected_baby.vaccinations.find_or_create_by!(name: vac[:name]) do |v|
          v.status = false
        end
      end

      @vaccinations_by_age = @selected_baby.vaccinations
        .group_by { |v| age_label_for(v.name) }
    end
  end
end

  def update
    @vaccination = Vaccination.find(params[:id])

    if @vaccination.update(status: params[:status])
      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  private

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
    { name: "DTCaP - rappel ado",       age: 132 },
  ].freeze

  AGE_LABELS = {
    0   => "Naissance",
    2   => "2 mois",
    4   => "4 mois",
    5   => "5 mois",
    11  => "11 mois",
    12  => "12 mois",
    16  => "16-18 mois",
    72  => "6 ans",
    132 => "11 ans",
  }

  def age_label_for(name)
    vac = VACCINES_LIST.find { |v| v[:name] == name }
    vac ? "#{vac[:age]} mois" : "Autre"
  end
end
