require 'spec_helper'

describe ClipsController do
  let (:clip) { FactoryGirl.create(:clip) }

  before_sign_in
  before { clip }

  describe "PUT 'reclip'" do
    it "returns http error" do
      expect { put :reclip, id: clip.id }.to raise_error(ActionView::MissingTemplate)
    end
  end

  describe "PUT 'unreclip'" do
    it "returns http error" do
      expect { put :unreclip, id: clip.id }.to raise_error(ActionView::MissingTemplate)
    end
  end

  describe "XHR-PUT 'reclip'" do
    before { xhr :put, :reclip, id: clip.id }

    its (:response) { should be_success }
    its (:current_user) { should be_present }

    it 'リクリップに成功していること' do
      assigns[:clip].parent_id.should eq(clip.id)
    end
  end

  describe "XHR-PUT 'unreclip'" do
    before { xhr :put, :reclip, id: clip.id }
    before { xhr :put, :unreclip, id: clip.id }

    its (:response) { should be_success }
    its (:current_user) { should be_present }

    it 'リクリップ解除に成功していること' do
      assigns[:clip].destroyed?.should be_true
    end
  end
end
