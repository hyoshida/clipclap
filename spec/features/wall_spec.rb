require 'spec_helper'

feature "ウォール" do
  given(:clip) { FactoryGirl.create(:clip) }

  background_stub_request
  background { visit root_path }

  scenario "ページが正常に表示されること" do
    page.should have_content(Settings.site_name)
  end

  scenario "無限スクロールが正常に動作すること", js: true do
    per_page = Settings.page
    FactoryGirl.create_list(:clip, per_page + 1)

    visit current_path
    page.should have_css('.box', count: per_page)

    # refs http://www.tweetegy.com/2013/05/testing-infinite-scroll-using-rspec-without-sleep-or-wait-until/
    # ただしスクロールのみではなぜか発動しないので、スクロールしたことをinfinitescrollに伝える
    page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
    page.execute_script('$("#container").infinitescroll("scroll")')

    page.should have_css('.box', count: Clip.count)
  end
end
