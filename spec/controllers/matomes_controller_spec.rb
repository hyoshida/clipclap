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

  describe "GET 'new'" do
    before { get :new }
    its (:response) { should be_success }
  end

  describe "GET 'edit'" do
    before { get :edit, id: matome.id }

    its (:response) { should be_success }

    context "@matome" do
      subject { assigns :matome }
      it { should be_persisted }
      its (:clip_ids) { should match_array(clips.map(&:id)) }
    end
  end

  describe "PUT 'update'" do
    before_sign_in

    let (:title) { '更新後のまとめタイトル' }
    let (:description) { '更新後のまとめ説明' }
    let (:new_clip_ids) { FactoryGirl.create_list(:clip, 5, user: controller.current_user).map(&:id) }

    before { put :update, id: matome.id, matome: { title: title, description: description, clip_ids: new_clip_ids } }

    its (:response) { should redirect_to(matome_path(assigns :matome)) }

    context "@matome" do
      subject { assigns :matome }
      it { should be_persisted }
      its (:title) { should eq(title) }
      its (:description) { should eq(description) }
      its (:clip_ids) { should match_array(new_clip_ids) }
    end
  end

  describe "XHR GET 'clips'" do
    before_sign_in
    before { xhr :get, :clips }
    its (:response) { should be_success }
  end

  describe "GET 'clips'" do
    before_sign_in
    subject { get :clips }
    it { expect { subject }.to raise_error(ActionView::MissingTemplate) }
  end

  describe "XHR POST 'like'" do
    before_sign_in
    before { xhr :post, :like, id: matome.id }
    its (:response) { should be_success }

    context "@matome" do
      subject { assigns :matome }
      its (:likes) { should have(1).items }
    end
  end

  describe "XHR DELETE 'unlike'" do
    before_sign_in
    before { xhr :post, :like, id: matome.id }
    before { xhr :delete, :unlike, id: matome.id }
    its (:response) { should be_success }

    context "@matome" do
      subject { assigns :matome }
      its (:likes) { should be_empty }
    end
  end
end
