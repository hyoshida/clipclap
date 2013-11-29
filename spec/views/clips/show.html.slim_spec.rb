require 'spec_helper'

describe "clips/show.html.slim" do
  before_stub_request
  before { assign(:clip, clip) }
  before { render }

  subject { response }

  context "通常クリップの場合" do
    let (:clip) { FactoryGirl.create(:clip) }

    it "正常にページが表示できること" do
      expect(rendered).to match /#{clip.title}/
    end

    it "通常画像が表示されていること" do
      should have_css("img[src*='#{image_path(clip.image_id)}']")
    end
  end

  context "リクリップの場合" do
    let (:clip) { FactoryGirl.create(:clip, :reclip) }

    it "正常にページが表示できること" do
      expect(rendered).to match /#{clip.title}/
    end

    it "リクリップページであること" do
      expect(rendered).to match /リクリップ/
    end
  end

  context "リクリップ元が削除されている場合" do
    let (:clip) { FactoryGirl.create(:clip, :destroyed_parent) }

    it "正常にページが表示できること" do
      expect(rendered).to match /#{clip.title}/
    end
  end
end
