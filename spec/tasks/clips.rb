FactoryGirl.define do
  ORIGIN_URL_LIST = %w( 
    http://livedoor.blogimg.jp/rjc/imgs/f/d/fdb4a54c.jpg
    http://blog-imgs-53.fc2.com/f/e/e/feeeln/750_1.jpg
    http://livedoor.3.blogimg.jp/chihhylove/imgs/8/0/80197df0.jpg
    http://livedoor.3.blogimg.jp/chihhylove/imgs/2/8/284b2927.jpg
    http://livedoor.blogimg.jp/rjc/imgs/f/1/f1577169-s.jpg
    http://livedoor.3.blogimg.jp/chihhylove/imgs/b/1/b1ace463.jpg
    http://www.ebookjapan.jp/ebj/
    http://www.ebookjapan.jp/ebj/
    http://www.ebookjapan.jp/ebj/
  )

  factory :dummy_clip, class: Clip do
    user_id 1
    title ''
    origin_html nil
    created_at Time.now
    updated_at Time.now
    sequence(:origin_url) {|n| ORIGIN_URL_LIST[n % ORIGIN_URL_LIST.size] }
    sequence(:image_master_id) {|n| (n % ORIGIN_URL_LIST.size) + 1 }
  end
end
