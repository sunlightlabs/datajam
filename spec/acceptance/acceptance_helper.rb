require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'capybara/rspec'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def create_admin
  User.create!(:email => 'test@test.com', :password => 'password')
end

def login_as_admin
  visit '/admin'
  page.should have_content('Sign in')
  fill_in 'Email',    :with => 'test@test.com'
  fill_in 'Password', :with => 'password'
  click_button 'Sign in'
  page.should have_content('Signed in successfully')
end
