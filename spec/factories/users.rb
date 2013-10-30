# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :user do
    name '光土比亜'
    description 'よろしくお願いします！'
    email 'user@codepia.tk'
    password 'foobar'
  end

  factory :has_clip_user, class: User do
    name 'クリップ太郎'
    email 'clip@codepia.tk'
    password 'piyopiyo'
  end
end
