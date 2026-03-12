class UserBabiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @user_baby = UserBaby.new
  end

  def create
    @user_baby = UserBaby.new(baby_params)
    @user_baby.user = current_user
    # @baby.name = params[:name]
    # @baby.birth_date = params[:birth_date]
    # @baby.weight = params[:weight]
    # @baby.doctor = params[:doctor]

    if @user_baby.save
      redirect_to_user_baby_path(@user_baby)
    else
      render "pages/home", status: :unprocessable_entity
    end
  end

  def show
    @user_baby = UserBaby.find(params[:id])
  end

  def edit
    @user_baby = UserBaby.find(params[:id])
  end

  def update
    @user_baby = UserBaby.find(params[:id])
    if @user_baby.update!(baby_params)
      redirect_to_user_baby_path(@user_baby)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_baby = UserBaby.find(params[:id])
    @user_baby.destroy
    redirect_to "pages/home", status: :see_other
  end

  private

  def baby_params
    params.require(:user_baby).permit(:name, :birth_date, :weight, :doctor, :avatar)
  end
end
