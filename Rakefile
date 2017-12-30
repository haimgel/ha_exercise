
require "rake"
require "rake/clean"

require_relative 'config/environment'

desc "Run model specs"
task :model_spec do
  sh %{#{FileUtils::RUBY} spec/unit.rb}
end

desc "Run web specs"
task :web_spec do
  sh %{#{FileUtils::RUBY} spec/integration.rb}
end

desc "Run model and web specs"
task :default=>[:model_spec, :web_spec]

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"
    Sequel.extension :migration
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(DB, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(DB, "db/migrations")
    end
  end
end
