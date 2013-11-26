require 'spec_helper'

describe "matomes/edit.html.slim" do
  before_stub_request
  before { assign(:matome, matome) }
  before { assign(:clips, matome.clips) }
  before { render }

  subject { response }

  context "まとめが存在する場合" do
    let (:clips) { FactoryGirl.create_list(:clip, 5) }
    let (:matome) { FactoryGirl.build(:matome, clips: clips) }

    it { should render_template(partial: '_form') }
    it { should have_field(:matome_title, type: 'text', with: matome.title) }
    it { should have_field(:matome_description, type: 'textarea', with: matome.description) }

    it "クリップが表示されていること" do
      should have_css("img[src*='#{image_path(clips.first.image_id)}']")
    end
  end

  context "0クリップのまとめが存在する場合" do
    let (:matome) { FactoryGirl.build(:matome) }

    it "クリップが表示されていないこと" do
      should_not have_css('img')
    end
  end
end
