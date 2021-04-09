class PagesController < ApplicationController
  before_action :prepare_data, only: :home

  def home
    @user = User.new
    respond_to do |format|
      format.json do
        html = render_to_string(
          partial: 'movies/movie',
          collection: @movies,
          as: :movie,
          layout: false,
          formats: [:html]
        )
        render json: { success: true, html: html, next_page: @pagy.next, last_page: @pagy.page == @pagy.last, movie_ids: @movies.pluck(:id) }
      end
      format.html
    end
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
      prepare_data
      render 'home'
    end
  end

  def prepare_data
    @movies = Movie.order(id: :desc)
    @pagy, @movies = pagy(Movie.order(id: :desc), items: 5)
  end
end
