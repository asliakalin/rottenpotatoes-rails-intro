class MoviesController < ApplicationController
helper_method :hilite

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    if !params[:order].nil?
      session[:order] = params[:order] 
    end 
    if params[:order].nil? && !session[:order].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    elsif params[:ratings].nil? && !session[:ratings].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    elsif (!params[:ratings].nil?) || (!params[:order].nil? && !params[:ratings].nil?)
      checked = params[:ratings].keys
      @movies = Movie.where(rating: checked).order(session[:order])
    elsif (!params[:ratings].nil? || !params[:order].nil?)
      @movies = Movie.all.order(session[:order])
    elsif !session[:order].nil? || !session[:ratings].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    else
      @movies=Movie.all
    end
    return @movies
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def hilite(section)
    return "p-3 mb-2 bg-warning text-dark hilite" if (params[:order] == section)
  end


end
