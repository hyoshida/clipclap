FactoryGirl.define do
  factory :matome do
    user { FactoryGirl.create(:has_clip_user) }
    sequence(:title) {|n| "まとめ#{n}" }
  end
end
