require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require 'vcr'
require 'webmock'
require 'simplecov'

require_relative '../init'

SimpleCov.start

GROUP_ID = '302165911402681'
# CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
# ACCESS_TOKEN = CONFIG['FB_TOKEN']
ACCESS_TOKEN = NoFB::App.config.FB_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/nofb_results.yml'))

# CASSETTES_FOLDER = 'spec/fixtures/cassettes'
# CASSETTE_FILE = 'Nofb_api'

ENV['RACK_ENV'] = 'test'