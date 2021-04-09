class MoviesController < ApplicationController
  before_action :authenticate_user!

  def new
    @movie = current_user.movies.new
  end

  def create
    @movie = current_user.movies.new(movie_params)

    if @movie.save
      redirect_to root_path, notice: 'Movie shared succesfully'
    else
      render :new
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:movie_url, :user_id)
  end
end