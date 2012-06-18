require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Admin area' do
  background {
    create_admin
  }

  scenario 'Sign in' do
    login_as_admin
  end

  scenario 'Viewing event templates' do
    login_as_admin

    visit 'admin/events_templates'
    page.has_link? "#new"
    page.has_link? "#index"
  end

  scenario 'Viewing embeds templates' do
    login_as_admin

    visit 'admin/embeds_templates'
    page.has_link? "#new"
    page.has_link? "#index"
  end
end
