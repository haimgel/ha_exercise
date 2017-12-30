
require_relative 'config/environment'

Dir['./models/**/*.rb'].each { |rb| Unreloader.require rb }

require 'faye/websocket'
require 'eventmachine'
Faye::WebSocket.load_adapter('thin')


class App < Roda

  use Rack::MethodOverride
  use Rack::Session::Cookie, secret: ENV['SECRET'] || SecureRandom.hex
  use Rack::CommonLogger, Log

  plugin :render,
         engine: 'haml',
         views: 'views',
         template_opts: { default_encoding: 'UTF-8' }

  plugin :public
  plugin :partials, views: 'views'
  plugin :assets, css: %w[app.scss], js: %w[app.js view_device.js edit_device_type.js]
  plugin :content_for, append: false
  plugin :all_verbs
  plugin :indifferent_params
  plugin :flash
  plugin :json
  plugin :status_handler
  plugin :multi_route
  plugin :halt

  status_handler(404) do
    view('404')
  end
  status_handler(500) do
    view('500')
  end

  Dir['./routes/**/*.rb'].each { |rb| Unreloader.require rb }

  route do |r|

    if Faye::WebSocket.websocket?(env)
      # Websocket routing
      r.on 'devices' do
        r.is Integer do |id|
          @device = Device[id]
          r.halt websocket_handler(@device, Faye::WebSocket.new(env))
        end
      end
    else
      # Regular HTTP routing
      r.assets
      r.public
      r.multi_route
      r.root do
        r.redirect '/devices'
      end
    end

  end

  Unreloader.require './lib/helpers.rb'

end

