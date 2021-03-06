require 'rake/testtask'

task :default do
  puts `rake -T`
end

# desc 'Run unit and integration tests'
# Rake::TestTask.new(:spec) do |t|
#   t.pattern = 'spec/test/{integration, unit}/**/*_spec.rb'
#   t.warning = false
# end

desc 'Run unit and integration tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/tests/**/*_spec.rb'
  t.warning = false
end

# desc 'Run unit and integration tests'
# Rake::TestTask.new(:spec_all) do |t|
#   t.pattern = 'spec/tests/**/*_spec.rb'
#   t.warning = false
# end

desc 'Keep rerunning unit/integration tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

# # NOTE: run `rake run:test` in another process
# desc 'Run acceptance tests'
# Rake::TestTask.new(:spec_accept) do |t|
#   t.pattern = 'spec/tests/acceptance/*_spec.rb'
#   t.warning = false
# end

# desc 'Keep restarting web app upon changes'
# task :rerack do
#   sh "rerun -c rackup --ignore 'coverage/*'"
# end

namespace :run do
  desc 'Run API in dev mode'
  task :dev do
    sh 'rerun -c "rackup -p 9090"'
  end

  desc 'Run API in test mode'
  task :test do
    sh 'RACK_ENV=test rackup -p 9090'
  end
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment' # load config info
    require_relative 'spec/helpers/database_helper'
 
    def app() = NoFB::App
  end
  
  desc 'Run migrations'
  task :migrate => :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'app/infrastructure/database/migrations')
  end
  
  desc 'Wipe records from all tables'
  task :wipe => :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end
    
    require_relative 'app/infrastructure/database/init'
    require_relative 'spec/helpers/database_helper'
    DatabaseHelper.wipe_database
  end
  
  desc 'Delete dev or test database file (set correct RACK_ENV)'
  task :drop => :config do
    if app.environment == :production
      puts 'Do not damage production database!'
      return
    end
  
    FileUtils.rm(NoFB::App.config.DB_FILENAME)
    puts "Deleted #{NoFB::App.config.DB_FILENAME}"
  end
end

desc 'Run application console'
task :console do
  sh 'pry -r ./init'
end

desc 'update spec/fixtures/nofb_results.yml'
task :update_yml do
  sh 'ruby lib/project_info.rb'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
        puts(ok ? 'Cassettes deleted': 'No cassettes found')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  task :rubocop do
    sh 'rubocop'
  end

  task :reek do
    sh "reek #{only_app}"
  end

  task :flog do
    sh "flog -m #{only_app}"
  end
end