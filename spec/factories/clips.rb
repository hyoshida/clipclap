# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :clip do
    user { FactoryGirl.create(:has_clip_user) }
    sequence(:title) {|n| "クリップ#{n}" }
    url 'http://www.google.co.jp/images/srpr/logo11w.png'
    origin_url 'http://www.google.co.jp/'
    origin_html '<html><body><p><img src="http://www.google.co.jp/images/srpr/logo11w.png" /></p></body></html>'

    trait :reclip do
      parent { Clip.first || FactoryGirl.create(:clip) }
      image { parent.image }
    end

    trait :destroyed_parent do
      parent_id 999
      image { Image.first || FactoryGirl.create(:image) }
    end
  end
end
