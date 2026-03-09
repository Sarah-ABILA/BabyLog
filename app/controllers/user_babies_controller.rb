class UserBabiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @baby = UserBaby.new
  end

  def create
    @baby = UserBaby.new(baby_params)
    @baby.user = current_user
    @baby.name = params[:name]
    @baby.birth_date = params[:birth_date]
    @baby.weight = params[:weight]

    if @baby.save
      redirect_to baby_path(@baby)
    else
      render "pages/home", status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def baby_params
    params.require(:user_babies).permit(:name, :birth_date, :weight)
  end
end
