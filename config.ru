require './application'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser

run Rack::URLMap.new('/' => Application, '/sidekiq' => Sidekiq::Web)