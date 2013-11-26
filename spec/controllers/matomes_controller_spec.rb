require 'spec_helper'

describe MatomesController do
  let (:clips) { FactoryGirl.build_list(:clip, 5) }
  let (:matome) { FactoryGirl.create(:matome, clips: clips) }

  before_stub_request
  before { matome }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get :show, id: matome.id
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    before { get :edit, id: matome.id }

    its (:response) { should be_success }

    context "@matome" do
      subject { assigns :matome }
      it { should be_persisted }
    end

    context "@clips" do
      subject { assigns :clips }
      it { should be_present }
      its (:count) { should eq(clips.count) }
    end
  end
end
