class MoviesController < ApplicationController
  helper_method :sort_column
  helper_method :chosen_rating?
  helper_method :highlight

  # See Section 4.5: Strong Parameters below for an explanation of this method:
  # http://guides.rubyonrails.org/action_controller_overview.html
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:order] = params[:order] unless params[:order].nil?
    
    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:order].nil? && !session[:order].nil?)
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
      
    elsif !params[:ratings].nil? 
      array_ratings = params[:ratings].keys
      return @movies = Movie.where(rating: array_ratings).order(session[:order])
      
    elsif !params[:order].nil?
        return @movies = Movie.all.order(session[:order])
        
    elsif !session[:ratings].nil? || !session[:order].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
      
    else
      return @movies = Movie.all
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

  private :movie_params
  
  def sort_column
  Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end
  
  def highlight(column)
    if(session[:order].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end

  def chosen_rating?(rating)
    chosen_ratings = session[:ratings]
    return true if chosen_ratings.nil?
    chosen_ratings.include? rating
  end
end
