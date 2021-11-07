# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
  FB_CASSETTE = 'NoFB_api'.freeze

  def self.setup_vcr    
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_fb
    VCR.configure do |c|
      c.filter_sensitive_data('<FB_TOKEN>') { FB_TOKEN }
      c.filter_sensitive_data('<FB_TOKEN_ESC>') { CGI.escape(FB_TOKEN) }
    end

    VCR.insert_cassette(
      FB_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
