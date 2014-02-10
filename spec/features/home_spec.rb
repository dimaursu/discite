require 'spec_helper.rb'
require 'pages/home_page.rb'

describe HomePage do
  before do
    visit root_url
  end

  it 'should display latest courses' do
    expect(page).to have_content
  end
end
