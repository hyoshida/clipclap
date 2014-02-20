# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :tag do
    user { FactoryGirl.create(:has_clip_user) }
    sequence(:name) {|n| "タグ#{n}" }
  end
end
