# frozen_string_literal: true

require_relative '../init'

require 'figaro'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
class CrawlerWorker
  # Environment variables setup
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand_path('config/secrets.yml')
  )
  Figaro.load
  def self.config() = Figaro.env

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

  def perform(_sqs_msg, request)
    command = JSON.parse request
    puts "MSG: #{command}"

    case command
    when 'openDriver'
      @@crawler_obj = NoFB::Value::WebCrawler.new # (headless: false)
    when 'testDriver'
      @@crawler_obj.test
    when 'testLogin'
      @@crawler_obj.login
    when 'testWait'
      @@crawler_obj.wait_home_ready
    when 'goAnyway'
      @@crawler_obj.goto_group_page_anyway
    when 'updateDB'
      @@crawler_obj.crawl
      puts @@crawler_obj.construct_query
      @@crawler_obj.insert_db
      # puts Database::PostsOrm.all
    when 'showCrawler'
      puts "show => #{@@crawler_obj}"
    end
  rescue StandardError => e
    puts "#{e.class.name} #{e.message}"
    puts e.backtrace.join("\n")
  end
end
