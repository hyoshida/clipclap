require 'spec_helper'

feature "ウォール" do
  given(:clip) { FactoryGirl.create(:clip) }

  background_stub_request
  background { visit root_path }

  scenario "ページが正常に表示されること" do
    page.should have_content(Settings.site_name)
  end
end
