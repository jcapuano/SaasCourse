class MoviesController < ApplicationController
  #def initialize
    #@all_ratings = Movie.all_ratings  
  #end
  
  
  helper_method :sort_by_title?
  helper_method :sort_by_date?
  helper_method :rating_selected?
  
  def sort_by_title?
    return @sort_by == "title"
  end

  def sort_by_date?
    @sort_by == "date"
  end
  
  def rating_selected?(rating)
    @selected_ratings.include?(rating)
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
    elsif session[:ratings] != nil
      @selected_ratings = session[:ratings]
    else
      @selected_ratings = []
    end
    opts = Hash.new    

    if @selected_ratings.count > 0
      opts[:conditions] = {:rating => @selected_ratings}
    end
    
    if params[:sort_by] != nil
      @sort_by = params[:sort_by]
    elsif session[:sort_by] != nil
      @sort_by = session[:sort_by]
    end
    if sort_by_title?
      opts[:order] = "title"      
    elsif sort_by_date?      
      opts[:order] = "release_date"      
    end
    
    if @sort_by != session[:sort_by]
      session[:sort_by] = @sort_by
    end
    if @selected_ratings != session[:ratings] and @selected_ratings != []
      session[:ratings] = @selected_ratings
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
