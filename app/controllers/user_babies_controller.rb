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
      redirect_to root_path
    else
      render "root", status: :unprocessable_entity
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
    update_params = baby_params
    update_params = update_params.except(:avatar) unless params[:user_baby][:avatar].present?
    if @user_baby.update!(baby_params)
      redirect_to root_path
    else
      render :edit, :show, status: :unprocessable_entity
    end
  end

  def destroy
    @user_baby = UserBaby.find(params[:id])
    @user_baby.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def baby_params
    params.require(:user_baby).permit(:name, :birth_date, :weight, :doctor, :avatar)
  end
end
