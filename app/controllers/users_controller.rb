class UsersController < ApplicationController

  before_action :set_user, only: [:show, :update, :destroy]

  #Get /users
  def index
    @users = User.all

    render json: @users
  end

  #Get /users/1
  def show
    render json: @user, :include => :blogs, status: :ok
  end

  #Post /users
  def create
    @user = User.new(user_params)

    if @user.save
      @token = encode({id: @user.id})
      render json: {
        user: @user.attributes.except("password_digest"),
        token: @token
      }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  #Patch/Put /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  #Delete /users/1
  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :imgurl)
  end
end
