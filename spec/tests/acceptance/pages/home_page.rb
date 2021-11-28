# frozen_string_literal: true

# Page object for home page
class HomePage
  include PageObject

  page_url NoFB::App.config.APP_HOST

  a(:nav_nofb, id: 'nav_nofb')
  a(:nav_home, id: 'nav_home')
  a(:nav_github, id: 'nav_github')

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h1(:title_heading, id: 'main_header')
  p(:description, id: 'description')
  button(:login, id: 'login')

  def click_login
    self.login
  end
end