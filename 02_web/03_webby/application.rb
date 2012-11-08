
require 'bundler/setup'
require 'rubygems'
require 'sinatra/base'
require 'sinatra/respond_to'
require 'padrino-helpers'
require 'rack/csrf'
require 'rack/methodoverride'
require 'supermodel'
require 'haml'
require 'json'

# ----------------------------------------------------
# models
# ----------------------------------------------------
class Location < SuperModel::Base
  include SuperModel::RandomID
  attributes :name, :lat, :lon
end

# ----------------------------------------------------
# web app
# ----------------------------------------------------
class Webby < Sinatra::Base
  register Sinatra::RespondTo                                                   # routes .html to haml properly
  register Padrino::Helpers                                                     # enables link and form helpers

  set :views, File.join(File.dirname(__FILE__), 'views')                        # views directory for haml templates
  set :public_directory, File.dirname(__FILE__) + 'public'                      # public web resources (images, etc)

  configure do                                                                  # use rack csrf to prevent cross-site forgery
    use Rack::Session::Cookie, :secret => "in a real application we would use a more secure cookie secret"
    use Rack::Csrf, :raise => true
  end

  helpers do                                                                    # csrf link/tag helpers
    def csrf_token
      Rack::Csrf.csrf_token(env)
    end

    def csrf_tag
      Rack::Csrf.csrf_tag(env)
    end
  end

  # --- Core Web Application : index ---
  get '/' do
    haml :'index', :layout => :application
  end

  # --- Core Web Application : locations ---
  get '/locations/?' do
    @locations = Location.all
    haml :'locations/index', :layout => :application
  end

  get '/locations/new' do
    @location = Location.new
    haml :'locations/edit', :layout => :application
  end

  get '/locations/:id' do
    @location = Location.find(params[:id])
    haml :'locations/show', :layout => :application
  end

  get '/locations/:id/edit' do
    @location = Location.find(params[:id])
    @action   = "/locations/#{params[:id]}/update"
    haml :'locations/edit', :layout => :application
  end

  post '/locations/?' do
    @location = Location.create!(params[:location])
    redirect to('/locations/' + @location.id)
  end

  post '/locations/:id/update' do
    @location = Location.find(params[:id])
    @location.update_attributes!(params[:location])
    redirect to('/locations/' + @location.id)
  end

  post '/locations/:id/delete' do
    @location = Location.find(params[:id])
    @location.destroy
    redirect to('/locations')
  end

  # --- Core Web Application : duckduckgo queries ---
  # TODO

  # --- Core Web Application : twitter queries ---
  # TODO

  run! if app_file == $0
end
