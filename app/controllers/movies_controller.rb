class MoviesController < ApplicationController
  #def initialize
    #@all_ratings = Movie.all_ratings  
  #end
  
  
  helper_method :sort_by_title?
  helper_method :sort_by_date?

  def sort_by_title?
    return @sort_by == "title"
  end

  def sort_by_date?
    @sort_by == "date"
  end

  def show  
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings  
    if params[:ratings] != nil
      @selected_ratings = params[:ratings].keys
    else
      @selected_ratings = []
    end
    opts = Hash.new    

    if @selected_ratings.count > 0
      opts[:conditions] = {:rating => @selected_ratings}
    end
    
    @sort_by = params[:sort_by]
    if sort_by_title?
      opts[:order] = "title"      
    elsif sort_by_date?      
      opts[:order] = "release_date"      
    end
    
    @movies = Movie.find(:all, opts)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
