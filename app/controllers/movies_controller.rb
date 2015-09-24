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
    params.each do |my_key,value|
      session[my_key] = params[my_key]
    end
    @ses_keys = session.keys
    @ses_keys.each do |key|
     if params[key] == nil
       params[key] = session[key]
       end
     end
    sort_param = params[:criteria]
    puts @title_header
    @movies = Movie.all.order(sort_param)
    @all_ratings = Movie.rat.uniq
    @rat_check = params[:ratings]
    if @rat_check.class != NilClass
      puts "Hello" , @rat_check.class
      @all_keys = @rat_check.keys
      @movies = Movie.all.order(sort_param).select { |m| @all_keys.include?m.rating}
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash.keep[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash.keep[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash.keep[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
