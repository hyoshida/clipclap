require 'spec_helper'

describe "matomes/index.html.slim" do
  before_stub_request
  before { assign(:matomes, subject) }
  before { render }

  context "まとめが存在する場合" do
    let (:clips) { FactoryGirl.build_list(:clip, 5) }

    subject { FactoryGirl.create_list(:matome, 1, clips: clips) }

    it "0以上のクリップのまとめが表示されていること" do
      expect(rendered).to match /#{clips.count}クリップ/
    end
  end

  context "0クリップのまとめが存在する場合" do
    subject { FactoryGirl.build_list(:matome, 1) }

    it "0クリップのまとめが表示されていること" do
      expect(rendered).to match /0クリップ/
    end
  end
end
