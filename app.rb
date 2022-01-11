require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative 'config/application'

configure do
  enable :sessions
end

before do
  @is_logged_in = !!session[:user_id]
end


get '/' do
  erb :index, :layout => :layout_background
end

get '/login' do
  erb :login, :layout => :layout_background
end

post '/login_check' do
  @user = User.find_by(username: params['username'])
  if @user
    if @user.password == params['password']
      session[:user_id] = @user.id
      redirect '/'
    else
      erb :password_fail, :layout => :layout_background
    end
  else
    erb :username_fail, :layout => :layout_background
  end
end

get '/signup' do
  erb :signup, :layout => :layout_background
end

post '/signup_check' do
  @user = User.find_by(username: params['username'])
  if @user
    erb :existing_user_fail, :layout => :layout_background
  else
    if params['password'] != params['password-confirmation']
      erb :passwords_mismatch, :layout => :layout_background
    else
      @new_user = User.create(username: params['username'], password: params['password'])
      session[:user_id] = @new_user.id
      redirect '/'
    end
  end
end

get '/new' do
  @user = User.find_by(id: session[:user_id])
  if @user
    erb :create, :layout => :layout_background
  else
    redirect '/login'
  end
end

get '/your_recipes' do
  # Display recipes that belongs to user
  @recipes = Recipe.where(user_id: session[:user_id])
  erb :your_recipes, :layout => :layout_white
end

post '/create_recipe' do
  @user = User.find_by(id: session[:user_id])
  if @user
    Recipe.create(name: params['name'], description: params['description'], rating: params['rating'], img_url: params['img_url'], user_id: session[:user_id])
    redirect '/your_recipes'
  else
    redirect '/login'
  end
end

get '/destroy/:id' do
  id = params['id'].to_i
  recipe_to_delete = Recipe.find(id)
  recipe_to_delete.destroy
  redirect '/your_recipes'
end

post '/import' do
  ingredient = params[:ingredient].to_s
  @web_recipes = ScrapeAllrecipesService.new(ingredient).scrapping
  @title = @web_recipes.empty? ? 'No results' : "#{@web_recipes.length} results"
  erb :import, :layout => :layout_white
end

get '/logout' do
  session.clear
  redirect '/'
end





# DO NOT CHANGE BELOW LINES
# Some configuration for Sinatra to be hosted and operational on Heroku
after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end
