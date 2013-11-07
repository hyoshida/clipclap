# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :clip do
    user { FactoryGirl.create(:has_clip_user) }
    title 'テストクリップ'
    url 'http://www.google.co.jp/images/srpr/logo11w.png'
    origin_url 'http://www.google.co.jp/'
    origin_html '<html><body><p><img src="http://www.google.co.jp/images/srpr/logo11w.png" /></p></body></html>'
  end
end
