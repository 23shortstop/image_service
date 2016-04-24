require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/json'
require 'mongoid'
require 'dotenv'
require 'sinatra-initializers'
require 'carrierwave/mongoid'
require './uploaders/image_uploader'
require './models/task'

Dotenv.load

class Application < Sinatra::Application
  register Sinatra::Initializers
  configure do
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
    set :public_folder, 'uploads'
  end

  get '/task' do
    param :id,  String,  required: true

    task = Task.find params['id']

    json(task.to_response)
  end

  post '/task' do
    param :operation, String,  required: true,  in: Task::OPERATION.map { |t| t.to_s }
    param :image,     String,  required: true
    param :params,    Hash,    required: true

    task = Task.new params
    task.remote_image_url = params['image']

    task.save!

    task = Task.create! params

    json(task.to_response)
  end

  error Sinatra::Param::InvalidParameterError do
    status 422
    { error: "#{env['sinatra.error'].param} is invalid" }.to_s
  end

  error Mongoid::Errors::DocumentNotFound do
    status 404
    { error: "Not found" }.to_s
  end
end
