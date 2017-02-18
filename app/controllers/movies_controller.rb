class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.getRatings
    
    if params[:ratings] == nil
      if session[:ratings] != nil
        params[:ratings] = session[:ratings]
        flash.keep
        redirect_to movies_path(:sort => params[:sort], :ratings => session[:ratings])  
        return
      else
        #need to keep the structure as a hash or else .keys wont work
        params[:ratings] = Hash[@all_ratings.map {|x| [x, 1]}]
        flash.keep
        redirect_to movies_path(:sort => params[:sort], :ratings =>params[:ratings])  
        return
      end
    end

    if params[:sort] == nil
      if session[:sort] != nil
        params[:sort] = session[:sort]
        flash.keep
        redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])  
        return
      end
    end

    #must have ratings
    @ratings_selected = params[:ratings].keys
    session[:ratings] = params[:ratings]

    @movies = Movie.where(:rating => @ratings_selected)

    if params[:sort] == 'title'
      @movies = @movies.order(:title)
      session[:sort] = 'title'
    elsif params[:sort] == 'release_date'
      @movies = @movies.order(:release_date)
      session[:sort] = 'release_date'
    end
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

end
