require './image_editor'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser

run Rack::URLMap.new('/' => ImageEditor, '/sidekiq' => Sidekiq::Web)