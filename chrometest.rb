# frozen_string_literal: true

require 'watir'
require 'webdrivers/chromedriver'
puts 'opening'
browser = Watir::Browser.new
puts 'opened Browser'
browser.goto('www.google.com')
puts 'goto-ed site'
browser.driver.save_screenshot('screenshot.png')
