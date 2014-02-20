require 'spec_helper'

describe "tags/show.html.slim" do
  # HACK: nameパラメータを無理矢理コントローラに渡す
  before { controller.stub!(:params).and_return { { name: subject.name } } }

  before_stub_request
  before { assign(:tag, subject) }
  before { render }

  context "タグづけされたクリップが存在する場合" do
    let (:clip) { FactoryGirl.create(:clip) }

    subject { FactoryGirl.create(:tag, tagged: clip, tagged_type: :clip) }

    it "クリップが１つが表示されていること" do
      expect(rendered).to match /クリップ \(1\)/
    end
  end

  context "タグづけされたクリップ/まとめが存在しない場合" do
    subject { FactoryGirl.build(:tag) }

    it "クリップが１つも表示されていないこと" do
      expect(rendered).to match /クリップ \(0\)/
    end
  end
end
