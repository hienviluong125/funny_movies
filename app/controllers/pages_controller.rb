class PagesController < ApplicationController
  def home
    @user = User.new
  end

  def login_register
    if params[:commit] == 'Login'
      handle_login
    elsif params[:commit] == 'Register'
      handle_register
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def handle_login
    @user = User.find_by(email: user_params[:email])

    return redirect_to root_path, alert: 'User not found!' if @user.blank?

    return redirect_to root_path, alert: 'Wrong password!' unless @user.valid_password?(user_params[:password])

    sign_in @user
    redirect_to root_path, notice: 'Logged succesfully'
  end

  def handle_register
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: 'Account registered successfully'
    else
      render 'home'
    end
  end
end
