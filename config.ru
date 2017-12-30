
require_relative 'config/environment'
require 'rack/unreloader'

# Monkey-patch to disable Rack::Lint in development, as it screws Faye::Websocket (which returns -1 'code')
module Rack
  class Lint
    def call(env = nil)
      @app.call(env)
    end
  end
end

Unreloader = Rack::Unreloader.new(
    subclasses: %w[Roda Sequel::Model],
    reload: Environment.development?,
    logger: Environment.development? ? Log : nil) { App }

# Show log lines immediately in RubyMine
STDOUT.sync = true if Environment.development?

Unreloader.require './ha_exercise.rb'
run Unreloader
