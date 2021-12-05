# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  FB_CASSETTE = 'NoFB_api'

  def self.setup_vcr
    VCR.configure do |cassette|
      cassette.cassette_library_dir = CASSETTES_FOLDER
      cassette.hook_into :webmock
      cassette.ignore_localhost = true # for acceptance tests
    end
  end

  # :reek:TooManyStatements
  def self.configure_vcr_for_fb(recording: :new_episodes)
    VCR.configure do |cassette|
      # puts "in vcr ENV['FB_TOKEN']: #{ENV['FB_TOKEN']}"
      cassette.filter_sensitive_data('<FB_TOKEN>') { ENV['FB_TOKEN'] }
      cassette.filter_sensitive_data('<FB_TOKEN_ESC>') { CGI.escape(ENV['FB_TOKEN']) }
    end

    VCR.insert_cassette(FB_CASSETTE, record: recording, match_requests_on: %i[method uri headers], allow_playback_repeats: true)
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
