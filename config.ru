require './application'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser

run Application
