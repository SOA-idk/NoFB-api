# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
  include PageObject::PageFactory

  before do
    DatabaseHelper.wipe_database
    # Headless error? https://github.com/leonid-shevtsov/headless/issues/80
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Visit Home page' do
    it '(HAPPY) should see home page' do
      visit HomePage do |page|
        _(page.nav_nofb).must_equal 'NoFB'
        _(page.nav_home).must_equal 'Home'
        _(page.nav_github).must_equal 'Github'

        _(page.warning_message.exists?).must_equal false
        _(page.success_message.exists?).must_equal false

        _(page.title_heading).must_equal 'NoFB'
        _(page.description).must_equal 'This is description of NoFB!!!'
        _(page.login.present?).must_equal true
      end
    end

    it '(HAPPY) should go to user page' do
      visit HomePage do |page|
        page.click_login
        @browser.url.include? 'user'
      end
    end
  end
end

