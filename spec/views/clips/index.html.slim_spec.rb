require 'spec_helper'

describe "clips/index.html.slim" do
  let (:clips) { FactoryGirl.create_list(:clip, 1) }
  let (:clip) { clips.first }

  before_stub_request
  before { assign(:clips, clips) }
  before { render }

  subject { response }

  it "正常にページが表示できること" do
    expect(rendered).to match /#{clip.title}/
  end

  it "サムネイル画像が表示されていること" do
    should have_css("img[src*='#{image_path(clip.image.thumb_url)}']")
  end
end
