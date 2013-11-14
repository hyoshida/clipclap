require 'spec_helper'

describe "clips/show.html.slim" do
  before_stub_request
  before { assign(:clip, subject) }
  before { render }

  context "通常クリップの場合" do
    subject { FactoryGirl.create(:clip) }

    it "正常にページが表示できること" do
      expect(rendered).to match /#{subject.title}/
    end
  end

  context "リクリップの場合" do
    subject { FactoryGirl.create(:clip, :reclip) }

    it "正常にページが表示できること" do
      expect(rendered).to match /#{subject.title}/
    end
  end

  context "リクリップ元が削除されている場合" do
    subject { FactoryGirl.create(:clip, :destroyed_parent) }

    it "正常にページが表示できること" do
      expect(rendered).to match /#{subject.title}/
    end
  end
end
