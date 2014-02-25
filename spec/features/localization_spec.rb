require 'spec_helper.rb'
require 'pages/profile_page'
require 'pages/login_page'

describe 'Localized application' do
  let(:user) { build(:user) }
  let(:profile) { ProfilePage.new(user) }

  xit 'should have a language switch' do
    # maybe is necessary to have a global language switch in the navigation bar
  end

  it 'should allow to set default language from profile' do
    profile.locale 'English'
    expect(user.language).to eq('en')
  end

  it 'should use the preffered language on a new session' do
    lang = :ro
    LoginPage.new(user)
    locale_file = File.open(Rails.root + "config/locales/#{lang}.yml")
    title = YAML.load(locale_file)[lang.to_s]['welcome_msg']
    profile.locale 'Romanian'
    visit '/'
    expect(page).to have_content(title)
  end
end
