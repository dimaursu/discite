require 'spec_helper'
require 'pages/home_page.rb'

describe 'front page' do
  let(:homepage) { HomePage.new }

  it 'should display latest courses' do
    homepage.visit_page
    expect(page).to have_content('Welcome to Discite, the interactive peer-to-peer teaching site')
  end
end
