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
    # session.clear
    
    if(!params.has_key?(:sort) && !params.has_key?(:ratings))
      if(session.has_key?(:sort))
          if(session.has_key?(:ratings))
            redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
          else
            redirect_to movies_path(:sort=>session[:sort])
          end
      else
        if(session.has_key?(:ratings))
          redirect_to movies_path(:ratings=>session[:ratings])
        end
          
      end
    end
    # @sort = params[:sort]
    # if(@sort == nil && session.has_key?(:sort))
    #   @sort = session[:sort]
    # end
      
    @sort = params.has_key?(:sort) ? (session[:sort] = params[:sort]) : session[:sort]
    @all_ratings = Movie.all_ratings.keys
    @select_rating = params[:ratings] || session[:ratings]||{}
    if @select_rating == {}
      @select_rating = Hash[Movie.all_ratings.map {|rating| [rating,rating]}]
    end
    @ratings = params[:ratings]
    if(@ratings != nil)
      ratings = @ratings.keys
      session[:ratings] = @ratings
      # @movies = Movie.where(rating: ratings).order(@sort)
    else
      if(!params.has_key?(:commit) && !params.has_key?(:sort))
        ratings = Movie.all_ratings.keys
        session[:ratings] = Movie.all_ratings
      else
        ratings = session[:ratings]
      end
      # if session[:ratings] == nil
      #   @movies = Movie.order(@sort)
      # else
      #   ratings = session[:ratings]
      #   @movies = Movie.where(rating: ratings).order(@sort)
      # end
    
    
    # if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
    #   session[:sort] = @sort
    #   session[:ratings] = @ratings
    #   redirect_to :sort=>session[:sort], :ratings=>session[:ratings] and return
    # end
    
    end
  @movies = Movie.where(rating: @select_rating.keys).order(@sort)
    
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
  
  def find_class(header)
    params[:sort] == header ? 'hilite' : nil
    # redirect_to movies_path
  end
  helper_method :find_class

end
