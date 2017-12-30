
require 'dotenv/load'
require 'roda'
require 'sequel'
require 'securerandom'
require 'logger'

module Environment
  ENVIRONMENT = ENV['RACK_ENV'] || 'development'
  def self.to_s
    ENVIRONMENT
  end
  def self.production?
    ENVIRONMENT == 'production'
  end
  def self.test?
    ENVIRONMENT == 'test'
  end
  def self.development?
    ENVIRONMENT == 'development'
  end
end

ROOT = ::File.expand_path('../..', __FILE__)

Log = Logger.new(::File.join(ROOT, 'log', "#{Environment}.log"), 4, 10*1024*1024)
Log.level = Environment.production? ? Logger::INFO : Logger::DEBUG

DB = Sequel.sqlite(::File.join(ROOT, 'db', "#{Environment}.sqlite3"), logger: Log)
