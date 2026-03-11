class UserBabiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @baby = UserBaby.new
  end

  def create
    @baby = UserBaby.new(baby_params)
    @baby.user = current_user
    # @baby.name = params[:name]
    # @baby.birth_date = params[:birth_date]
    # @baby.weight = params[:weight]
    # @baby.doctor = params[:doctor]

    if @baby.save
      redirect_to user_baby_path(@baby)
    else
      render "pages/home", status: :unprocessable_entity
    end
  end

  def show
    @baby = UserBaby.find(params[:id])
  end

  def edit
    @baby = UserBaby.find(params[:id])
  end

  def update
    @baby = UserBaby.find(params[:id])
    if @baby.update!(baby_params)
      redirect_to baby_path(@baby)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @baby = UserBaby.find(params[:id])
    @baby.destroy
    redirect_to "pages/home", status: :see_other
  end

  private

  def baby_params
    params.require(:user_baby).permit(:name, :birth_date, :weight, :doctor, :avatar)
  end
end
