require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Admin area' do

  background do
    User.create!(:email => 'test@test.com', :password => 'password')
  end

  scenario 'Sign in' do
    visit '/admin'
    page.should have_content('Sign in')
    fill_in 'Email',    :with => 'test@test.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    page.should have_content('Signed in successfully')
  end

end
