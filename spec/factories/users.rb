# -*- coding: utf-8 -*-
FactoryGirl.define do
  sequence(:email) {|n| "clip+#{n}@codepia.tk" }

  factory :user do
    name '光土比亜'
    description 'よろしくお願いします！'
    email
    password 'foobar'
  end

  factory :has_clip_user, class: User do
    name 'クリップ太郎'
    email
    password 'piyopiyo'
  end
end
