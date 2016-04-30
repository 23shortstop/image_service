require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/json'
require 'mongoid'
require 'dotenv'
require 'sinatra-initializers'
require 'carrierwave/mongoid'
require 'active_model_serializers'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'

require './uploaders/image_uploader'
require './models/task'
require './serializers/base_serializer'
require './serializers/task_serializer'
require './lib/worker'

Dotenv.load

class ImageEditor < Sinatra::Application
  register Sinatra::Initializers
  configure do
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
    set :public_folder, 'uploads'
  end

  get '/task' do
    param :id,  String,  required: true

    task = Task.find params['id']

    json(task)
  end

  post '/task' do
    param :operation, String,  required: true,  in: Task::OPERATION.map { |t| t.to_s }
    param :image,     String,  required: true
    param :params,    Hash

    task = Task.new params
    task.remote_image_url = params['image']

    task.save!

    Worker.perform_async(task.id.to_s)

    json (task)
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
